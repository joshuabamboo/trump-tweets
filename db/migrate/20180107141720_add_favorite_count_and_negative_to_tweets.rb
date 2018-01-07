class AddFavoriteCountAndNegativeToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :favorite_count, :integer
    add_column :tweets, :negative, :boolean
  end
end
