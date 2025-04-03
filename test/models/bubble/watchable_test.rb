require "test_helper"

class Bubble::WatchableTest < ActiveSupport::TestCase
  setup do
    Watch.destroy_all
    Access.all.update!(involvement: :access_only)
  end

  test "watched_by?" do
    assert_not bubbles(:logo).watched_by?(users(:kevin))

    bubbles(:logo).set_watching(users(:kevin), true)
    assert bubbles(:logo).watched_by?(users(:kevin))

    bubbles(:logo).set_watching(users(:kevin), false)
    assert_not bubbles(:logo).watched_by?(users(:kevin))
  end

  test "watched_by? when notifications are set on the bucket" do
    buckets(:writebook).access_for(users(:kevin)).watching!
    assert bubbles(:text).watched_by?(users(:kevin))

    bubbles(:logo).set_watching(users(:kevin), false)
    assert_not bubbles(:logo).watched_by?(users(:kevin))
  end

  test "bubbles are initially watched by their creator" do
    bubble = buckets(:writebook).bubbles.create!(creator: users(:kevin))

    assert bubble.watched_by?(users(:kevin))
  end

  test "watchers_and_subscribers" do
    buckets(:writebook).access_for(users(:kevin)).watching!
    buckets(:writebook).access_for(users(:jz)).everything!

    bubbles(:logo).set_watching(users(:kevin), true)
    bubbles(:logo).set_watching(users(:jz), false)
    bubbles(:logo).set_watching(users(:david), true)

    assert_equal [ users(:kevin), users(:david) ].sort, bubbles(:logo).watchers_and_subscribers.sort
  end
end
