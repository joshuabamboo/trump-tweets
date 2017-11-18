class TweetsController < ApplicationController
  def index
    @score = ((Tweet.daily_negatives.length/Tweet.todays_tweets.length.to_f).round(2)*100).to_i
    @latest = Tweet.latest
    @worst = Tweet.daily_worst
  end
end
