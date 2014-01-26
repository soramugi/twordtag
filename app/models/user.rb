class User < ActiveRecord::Base
  validates :provider, presence: :true
  validates :uid, presence: :true
  validates :name, presence: :true

  validates_uniqueness_of :uid, scope: :provider

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]

      if user.provider == "twitter"
        user.name      = auth["info"]["nickname"]
        user.image_url = auth["info"]["image"]
        user.token     = auth["credentials"]["token"]
        user.secret    = auth["credentials"]["secret"]
      else
        user.name      = auth["info"]["name"]
      end
    end
  end
end
