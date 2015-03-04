require 'minitest/autorun'
require 'policy/base'

class BaseTest < Minitest::Test
  def setup
    @policy = Policy::Base.new(:agent, :resource)
  end

  def test_everyone_can_do_everything_on_anything
    @policy.allowed_actions.each do |action|
      @policy.can?(action)
    end
  end

  def test_capabilities
    caps = @policy.capabilities
    assert_equal @policy.allowed_actions, caps.keys
    assert_equal [true], caps.values.uniq
  end
end
