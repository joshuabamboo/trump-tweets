class TweetsController < ApplicationController
  def index
    @score = Tweet.daily_average
  end
end
