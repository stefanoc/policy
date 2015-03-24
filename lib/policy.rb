require 'policy/version'
require 'policy/support'
require 'policy/resolver'
require 'policy/base'
require 'policy/agent'
require 'policy/resource'
require 'policy/multi_agent_support'
require 'policy/role_based_policy'

module Policy
  def self.[](klass)
    Resolver[klass]
  end
end
