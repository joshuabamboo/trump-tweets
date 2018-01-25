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

  def year
    @clinton_tweets = Tweet.tweets_that_include(['hillary', 'clinton', 'crooked'])
    @obama_tweets = Tweet.tweets_that_include(['barack', 'obama'], ['obamacare'])
    @trump_tweets = Tweet.tweets_that_include(['donald', 'trump', ' i ', ' me '], ['ivanka',' son', 'ballard'])
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

  def circle
    tweets = Tweet.all
    @results = [{year: '0'}]
    weeks = Array( Date.parse("2017-01-20")..Date.parse("2018-01-14") ).select(&:sunday?).map(&:to_s)
    weeks.each.with_index(1) do |d, i|
      tweet_count = Tweet.where(:date => Date.parse(d).beginning_of_week..Date.parse(d).end_of_day).size
      @results[0]["Week #{i}"] = tweet_count
    end
    respond_to do |format|
      format.json {render json: @results}
    end
  end

end
