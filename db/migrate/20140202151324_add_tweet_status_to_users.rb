class AddTweetStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tweet_status, :integer, :default => 0
  end
end
