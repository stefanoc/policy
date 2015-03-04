require 'minitest/autorun'
require 'policy/resolver'

class DefaultResolverTest < Minitest::Test
  def setup
    Policy::Resolver.default_policy = :default
  end

  def test_resolve_to_default
    assert_same :default, Policy::Resolver[Object.new]
  end

  def test_resolve_to_specific_policy
    Object.const_set(:Foo, Class.new)
    Object.const_set(:FooPolicy, Class.new)
    assert_same FooPolicy, Policy::Resolver[Foo.new]
  end

  def test_resolve_to_ancestor_policy
    Object.const_set(:Fog, Class.new)
    Object.const_set(:Bar, Class.new(Fog))
    Object.const_set(:FogPolicy, Class.new)
    assert_same FogPolicy, Policy::Resolver[Bar.new]
  end
end
