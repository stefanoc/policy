module Policy
  module MultiAgentSupport
    def self.included(base)
      allowed_agents.each do |klass|
        base.send(:alias_method, klass.name.underscore, :agent)
      end
    end

    def can?(action)
      send("#{agent.class.name.underscore}_can?", action)
    end
  end
end
