class TweetsController < ApplicationController
  def index
    @avg_score = Tweet.daily_average
    @recent_score = Tweet.last.sentiment_score
  end
end
