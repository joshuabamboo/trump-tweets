class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.string :content
      t.decimal :sentiment_score
      t.datetime :date

      t.timestamps
    end
  end
end
