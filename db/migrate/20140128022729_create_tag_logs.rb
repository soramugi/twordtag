class CreateTagLogs < ActiveRecord::Migration
  def change
    create_table :tag_logs do |t|
      t.integer :user_id
      t.date :date

      t.timestamps
    end
  end
end
