class AddTwitterIdToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :twitter_id, :integer, limit: 8
  end
end
