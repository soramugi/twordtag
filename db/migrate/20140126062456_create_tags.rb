class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :user_id
      t.string :word
      t.integer :count
      t.date :date

      t.timestamps
    end
  end
end
