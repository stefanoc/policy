require 'minitest/autorun'
require 'policy'

class RoleBasedPolicyTest < Minitest::Test
  class ::TestAgent < Struct.new(:role)
    include Policy::Agent
  end

  class ::TestResource
    include Policy::Resource
  end

  def setup
    Policy::Resolver.default_policy = Policy::RoleBasedPolicy
    Policy::RoleBasedPolicy.policy_definitions_root = '/tmp'
    definition = <<-EOT
      defaults: &DEFAULTS
        create: false
        read: true

      admin:
        <<: *DEFAULTS
        create: true
    EOT
    File.open('/tmp/test_resource.yml', 'w') { |f| f.write(definition) }
    @guest = TestAgent.new('guest')
    @admin = TestAgent.new('admin')
    @res   = TestResource.new
  end

  def test_guests_can_only_read
    assert_equal true, @guest.can?(:read, @res)
    assert_equal false, @guest.can?(:create, @res)
  end

  def test_admins_can_also_create
    assert true, @admin.can?(:read, @res)
    assert true, @admin.can?(:create, @res)
  end

  def test_definition_caching
    assert_equal ['/tmp/test_resource.yml'], Policy::RoleBasedPolicy.policy_definitions_cache.keys.map(&:to_s)
  end
end
