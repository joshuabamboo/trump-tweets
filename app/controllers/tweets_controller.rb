class TweetsController < ApplicationController
  def index
    if Tweet.todays_tweets.present?
      @score = ((Tweet.daily_negatives.length/Tweet.todays_tweets.length.to_f).round(2)*100).to_i
      if bad_tweet = Tweet.daily_worst
        @worst = bad_tweet.content
      end
    else
      render 'no-tweets'
    end
  end

  def data
    tweets = Tweet.all
    @results = []

    # get all uniq dates
    dates = Tweet.order(date: :asc).pluck(:date).map {|date| date.strftime('%b %d, %Y')}.uniq
    # iterate over them
    dates.each do |d|
      # get count for all tweets on that day
      tweet_count = Tweet.where(:date => Date.parse(d).beginning_of_day..Date.parse(d).end_of_day).size
      # add structured hash to results array
      @results.push({Date: d, Count: tweet_count})
    end
    respond_to do |format|
      # format.json {render json: @tweet}
      format.json {render json: @results}
      format.csv {render 'test.csv'}
    end
  end

end
