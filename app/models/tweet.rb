class Tweet < ApplicationRecord
  def self.new_from_twitter(tweet)
    formatted_text = tweet.attrs[:full_text].gsub('&amp;', '&')
    self.create do |t|
      t.content = formatted_text
      t.date = tweet.created_at
      t.sentiment_score = AnalyzeSentiment.new.score(formatted_text)
      t.reply_count = ScrapeReplies.new(tweet.url.to_s).reply_count
      t.retweet_count = tweet.retweet_count
      t.retweet = tweet.retweet?
      t.twitter_id = tweet.id
      # t.negative = t.potentially_negative?
    end
  end

  def potentially_negative?
    sentiment_score < -1 || reply_to_retweet_ratio > 1.5
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

  def reply_to_retweet_ratio
    reply_count / retweet_count.to_f
  end

  def self.worst_ratio
    todays_tweets.sort_by {|t| t.reply_to_retweet_ratio}.last
  end

  def self.most_replies
    todays_tweets.sort_by {|t| t.reply_count}.last
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

end
