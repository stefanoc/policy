require 'minitest/autorun'
require 'policy'

class ResolverTest < Minitest::Test
  def setup
    @resolver = Policy::Resolver.new(:default)
  end

  def test_resolve_to_default
    assert_same :default, @resolver.find_policy(Object.new)
  end

  def test_resolve_to_specific_policy
    Object.const_set(:Foo, Class.new)
    Object.const_set(:FooPolicy, Class.new)
    assert_same FooPolicy, @resolver.find_policy(Foo.new)
  end

  def test_resolve_to_ancestor_policy
    Object.const_set(:Fog, Class.new)
    Object.const_set(:Bar, Class.new(Fog))
    Object.const_set(:FogPolicy, Class.new)
    assert_same FogPolicy, @resolver.find_policy(Bar.new)
  end
end
