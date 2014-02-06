require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "self.create_with_user_tweet" do
    user = users(:one)
    user.stubs(:tweets).returns([
      Hashie::Mash.new(text: '果実'),
      Hashie::Mash.new(text: '梅'),
      Hashie::Mash.new(text: '果実')
    ])
    nouns = Tag.create_with_user_tweet user, Time.now.to_datetime
    example = Tag.where(word: ['果実', '梅'])
    assert_equal example, nouns
  end
  test "the generate" do
    nouns = Tag.generate 'httpと果実と梅と果実'
    assert_equal ["果実", "梅", "果実"], nouns
    nouns = Tag.generate 'のっぺらぼうと思うのです'
    assert_equal ["のっぺらぼう"], nouns
  end
end
