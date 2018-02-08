class Tweet < ApplicationRecord
  def self.new_from_twitter(tweet)
    formatted_text = tweet.attrs[:full_text].gsub('&amp;', '&')
    puts "creating tweet: #{tweet.created_at - 18000} --- #{formatted_text}"
    self.create do |t|
      t.content = formatted_text
      t.date = tweet.created_at - 18000
      t.sentiment_score = AnalyzeSentiment.new.score(formatted_text)
      t.favorite_count = tweet.favorite_count
      t.reply_count = ScrapeReplies.new(tweet.url.to_s, tweet.id, tweet.retweet?).reply_count
      t.retweet_count = tweet.retweet_count
      t.retweet = tweet.retweet?
      t.twitter_id = tweet.id
      t.negative = t.negative_prediction
    end
  end

  def negative_prediction
    if reply_count < 11000 && date < Date.today
      false
    # Added this for 'monitoring the situation' tweet. This should be its own logic
    elsif sentiment_score > 9
      false
    elsif reply_to_retweet_ratio < 0.79 && reply_count < 23000 && sentiment_score > -12
      false
    elsif reply_count < 25065 && sentiment_score > -0.53
      false
    elsif reply_to_retweet_ratio > 1 && sentiment_score < 0
      true
    elsif reply_to_retweet_ratio > 2
      true
    elsif sentiment_score < -1.96
      true
    elsif reply_to_retweet_ratio > 1.3 && reply_count > 35000
      true
    elsif reply_to_retweet_ratio > 1 && reply_count > 45000
      true
    end
  end

  def self.todays_tweets
    self.where('date > ?', 1.day.ago)
  end

  def self.daily_average
    tweets = todays_tweets
    tweets.sum {|tweet| tweet.sentiment_score} / tweets.size if !tweets.empty?
  end

  def self.latest
    self.order('twitter_id DESC').first
  end

  def self.worst_sentiment
    todays_tweets.order('sentiment_score').first
  end

  def self.daily_negatives
    todays_tweets.select {|t| t.sentiment_score < 0}
  end


  def self.worst_ratio
    todays_tweets.sort_by {|t| t.reply_to_retweet_ratio}.last
  end

  def self.most_replies
    todays_tweets.sort_by {|t| t.reply_count}.last
  end

  def self.most_liked
    self.all.sort_by {|t| t.favorite_count}.last # these could be more efficient, do at once instead of calling all and sort_by
  end

  def self.most_replied
    self.all.sort_by {|t| t.reply_count}.last
  end

  def self.most_retweeted
    self.all.sort_by {|t| t.retweet_count}.last
  end

  def self.word_mentions
    results = {}
    self.all.each do |t|
      words = t.content.scan(/\b\S+\b/)
      words.each do |word|
        formatted_word = word.downcase
        if !results[formatted_word]
          results[formatted_word] = 1
        else
          results[formatted_word] += 1
        end
      end
    end
    results
  end

  def self.tweets_that_include(words, ignore=nil)
    tweets = words.map do |word|
      self.where("lower(content) like lower(?)", "%#{word}%")
    end.flatten.uniq
    if ignore
      ignored = ignore.map {|word| self.where("lower(content) like lower(?)", "%#{word}%")}.flatten.uniq
      tweets = tweets - ignored
    end
    tweets
  end

  def self.all_time_worst
    top_replies = Tweet.all.sort_by {|t| t.reply_count}.last(250)
    top_ratios = Tweet.all.sort_by {|t| t.reply_to_retweet_ratio}.last(550)
    top_negatives = Tweet.all.sort_by {|t| t.sentiment_score}.first(300)
    results = top_replies & top_ratios & top_negatives
    results.each{|t|puts t.content;puts t.sentiment_score;puts ''}
  end


  def self.dates_with_no_tweets
    tweet_days = Tweet.pluck(:date).map {|date| date.to_date}.uniq
    everyday = Array( Date.parse("2017-01-20")..Date.parse("2018-01-20") )
  end


  def self.daily_worst
    ratio_tweet, sentiment_tweet, reply_tweet =
      self.worst_ratio, self.worst_sentiment, self.most_replies

    # holy shit. nailed it.
    if sentiment_tweet == ratio_tweet
      sentiment_tweet
    # if it's the most talked about and it has a lopsided ratio, it's bad
    elsif ratio_tweet == reply_tweet
      ratio_tweet
    # if the most replied tweet has twice as many replies as rt, it's bad
    elsif reply_tweet.reply_to_retweet_ratio > 2
      reply_tweet
    # if the score is this bad and there are at least and equal # replies/retweets
    elsif sentiment_tweet.sentiment_score <= -5 && sentiment_tweet.reply_to_retweet_ratio > 1
      sentiment_tweet
    # if a lot of people are talking and the score is negative
    elsif ratio_tweet.reply_to_retweet_ratio > 1.2 && ratio_tweet.sentiment_score < 0
      ratio_tweet
    # moderately bad on the sentiment
    elsif sentiment_tweet.sentiment_score <= -1
      sentiment_tweet
    # moderately bad on the ratio
    elsif ratio_tweet.reply_to_retweet_ratio > 1.2
      ratio_tweet
    end
  end



  # class method sentiment analysis
  def self.percentage_of_negative_tweets
    negative_count = self.where(negative: true).size
    total_count = self.where(negative: false).size + negative_count
    begin
      ((negative_count/total_count.to_f)*100).round
    rescue # if all tweets have no negative score
      0
    end
  end

  def self.tweets_by_date(date)
    self.where(date: Date.parse(date).beginning_of_day..Date.parse(date).end_of_day)
  end

  def self.negative_percentage_by_day
    result = {}
    self.group("DATE(date)").count.each do |date, tweet_total|
      daily_tweets = tweets_by_date("#{date}")
      negative_percentage = daily_tweets.percentage_of_negative_tweets

      result[date] = negative_percentage
    end
    result
  end

  def self.negative_dates
    negative_percentage_by_day.select {|date,percentage| percentage >= 50}.keys
  end

  def self.negative_count_by_day
    tweets = self.all
    @results = {}
    days = Array( Date.parse("2017-01-20")..Date.parse("2018-01-20") )
    days.each.with_index(1) do |d, i|
      todays_tweets = self.where(:date => d.beginning_of_day..d.end_of_day)
      neg_count = todays_tweets.where(negative: true).size
      @results[d] = neg_count
    end
    @results
    # daily average
    #@results.values.inject(:+)/@results.values.size.to_f
  end


  def self.negative_count_by_week
    tweets = self.all
    @results = {}
    weeks = Array( Date.parse("2017-01-20")..Date.parse("2018-01-20") ).select(&:sunday?)
    weeks.each.with_index(1) do |d, i|
      tweet_count = self.where(:date => d.beginning_of_week..d.end_of_day).count {|t| t.sentiment_score < 0}
      @results[d] = tweet_count
    end
    @results
  end

  def self.negative_count_by_month
    tweets = self.all
    @results = {}
    months = [ Date.parse("2017-01-01"), Date.parse("2017-02-01"), Date.parse("2017-03-01"), Date.parse("2017-04-01"), Date.parse("2017-05-01"), Date.parse("2017-06-01"), Date.parse("2017-07-01"), Date.parse("2017-08-01"), Date.parse("2017-09-01"), Date.parse("2017-10-01"), Date.parse("2017-11-01"), Date.parse("2017-12-01"), Date.parse("2018-01-20") ]
    months.each.with_index(1) do |d, i|
      tweet_count = self.where(:date => d.beginning_of_month..d.end_of_month).count {|t| t.sentiment_score < 0}
      @results[d] = tweet_count
    end
    @results
  end

  def self.worst_day
    results = negative_count_by_day
    results.key(results.values.sort.last)
  end

  def self.worst_week
    results = negative_count_by_week
    results.key(results.values.sort.last)
  end

  def self.worst_month
    results = negative_count_by_month
    results.key(results.values.sort.last)
  end

  def reply_to_retweet_ratio
    reply_count / retweet_count.to_f
  end
end
