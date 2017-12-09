class Tweet < ApplicationRecord

  def self.new_from_twitter(tweet)
    analyzer = AnalyzeSentiment.new
    formatted_text = tweet.attrs[:full_text].gsub('&amp;', '&')
    self.create do |t|
      t.content = formatted_text
      t.date = tweet.created_at
      t.sentiment_score = analyzer.score(formatted_text)
      t.comment_to_rt_ratio = analyzer.comment_to_rt_ratio(tweet)
      # t.retweet? =
      t.twitter_id = tweet.id
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

  def self.daily_worst
    todays_tweets.order('sentiment_score').first
  end

  def self.daily_negatives
    todays_tweets.select {|t| t.sentiment_score < 0}
  end
end
