class AddReplyCountAndRetweetCountAndRetweetToTweet < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :reply_count, :integer
    add_column :tweets, :retweet_count, :integer
    add_column :tweets, :retweet, :boolean
  end
end
