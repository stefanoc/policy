module Policy
  class Base
    class <<self
      attr_reader :allowed_agents

      def allow_agents(*list)
        @allowed_agents = list
      end
    end

    InvalidAgentType = Class.new(StandardError)

    DEFAULT_ACTIONS = [:create, :read, :update, :delete, :publish, :unpublish].freeze

    attr_reader :agent, :resource

    def initialize(agent, resource)
      @agent, @resource = agent, resource
      validate_agent!
    end

    def can?(action)
      allowed_actions.include?(action)
    end

    def capabilities
      allowed_actions.with_object({}) { |caps, action| caps[action] = can?(action) }
    end

    def allowed_actions
      DEFAULT_ACTIONS
    end

    def allowed_agents
      self.class.allowed_agents
    end

    private

    def validate_agent!
      raise(InvalidAgentType, agent.class.name) if allowed_agents && !allowed_agents.any? { |klass| agent.is_a?(klass) }
    end
  end
end
