class TweetsController < ApplicationController
  def index
    @score = Tweet.daily_negatives.length/Tweet.todays_tweets.length.to_f
    @latest = Tweet.latest
    @worst = Tweet.daily_worst
  end
end
