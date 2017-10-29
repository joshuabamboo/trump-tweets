class TweetsController < ApplicationController
  def index
    GetTweets.new
  end
end
