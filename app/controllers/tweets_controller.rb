class TweetsController < ApplicationController
  def index
    if Tweet.todays_tweets.present?
      @score = ((Tweet.daily_negatives.length/Tweet.todays_tweets.length.to_f).round(2)*100).to_i
      @worst = Tweet.daily_worst.content
    else
      render 'no-tweets'
    end
  end

  def data
    # @tweet = Tweet.all
    @data = File.read("data.json")
    respond_to do |format|
      # format.json {render json: @tweet}
      format.json {render json: @data}
    end
  end

end
