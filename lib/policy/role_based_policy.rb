module Policy
  class RoleBasedPolicy < Base
    class <<self
      attr_accessor :policy_definitions_root
    end

    PolicyDefinitionNotFound = Class.new(StandardError)
    InvalidPolicyDefinition  = Class.new(StandardError)

    def can?(verb)
      policy_definition.fetch(agent.role.to_s) { defaults }.fetch(verb.to_s, false)
    end

    private

    DEFAULTS_KEY = 'defaults'.freeze

    def defaults
      policy_definition.fetch(DEFAULTS_KEY)
    end

    def policy_definition
      @policy_definition ||= YAML.load(File.read(policy_definition_path)).tap do |defn|
        raise(InvalidPolicyDefinition, "Missing '#{DEFAULTS_KEY}' key") unless defn.has_key?(DEFAULTS_KEY)
      end
    rescue Errno::ENOENT
      raise(PolicyDefinitionNotFound, policy_definition_path)
    end

    def policy_definition_path
      @policy_definition_path ||= Pathname.new(RoleBasedPolicy.policy_definitions_root).join(resource.class.name.underscore + '.yml')
    end
  end
end
