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
    respond_to do |format|
      # format.json {render json: @tweet}
      format.csv {render csv: 'year,A,B,C,D,E,F,G
      0,401,150,0,144,48,410,803
      1,419,299,90,141,80,180,802
      2,468,440,97,95,48,42,860
      3,585,459,100,99,48,71,702
      4,462,634,89,80,44,104,670
      5,423,233,81,84,19,361,882'}
    end
  end
end
