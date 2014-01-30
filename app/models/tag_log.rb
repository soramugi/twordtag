class TagLog < ActiveRecord::Base
  belongs_to :user
  #has_many  :tags, foreign_key: 'user_id'
  #TODO has_manyで指定
  def tags
    Tag.where(user_id: user_id, date: date)
  end
end
