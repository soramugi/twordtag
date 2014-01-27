require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "self.create_with_user_tweet" do
    arr =[
      Hashie::Mash.new(text: '果実'),
      Hashie::Mash.new(text: '梅'),
      Hashie::Mash.new(text: '果実')
    ]
    nouns = Tag.create_with_user_tweet users(:one).id, arr, Time.now.to_datetime
    example = Tag.where(word: ['果実', '梅'])
    assert_equal example, nouns
  end
  test "the nouns" do
    nouns = Tag.nouns '果実と梅と果実'
    assert_equal ["果実", "梅", "果実"], nouns
  end
end
