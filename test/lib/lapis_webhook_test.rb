require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'test_helper')
require File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'lapis_webhook')

class LapisWebhookTest < ActiveSupport::TestCase
  def setup
    @lw = Lapis::Webhook.new('https://ca.ios.ba/', { foo: 'bar' }.to_json)
    super
  end

  test "should instantiate" do
    assert_not_nil @lw
  end

  test "should have signature" do
    assert_kind_of String, @lw.notification_signature({ foo: 'bar' }.to_json)
  end

  test "should notify" do
    assert_kind_of Net::HTTPOK, @lw.notify
  end
end
