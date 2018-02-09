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
    @hall_of_shame = Tweet.all_time_worst
  end

  def data
    @results = File.read("all-tweets.json")
    respond_to do |format|
      format.json {render json: @results}
    end
  end

  def circle
    tweets = Tweet.all
    @results = [{year: '0'}]
    weeks = Array( Date.parse("2017-01-20")..Date.parse("2018-01-20") ).select(&:sunday?).map(&:to_s)
    weeks.each.with_index(1) do |d, i|
      tweet_count = Tweet.where(:date => Date.parse(d).beginning_of_week..Date.parse(d).end_of_day).size
      @results[0]["Week #{i}"] = tweet_count
    end
    respond_to do |format|
      format.json {render json: @results}
    end
  end



end
