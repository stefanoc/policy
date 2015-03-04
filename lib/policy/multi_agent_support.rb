module Policy
  module MultiAgentSupport
    def self.included(base)
      base.allowed_agents.each do |klass|
        base.send(:alias_method, Support.underscore(klass.name.split('::')[-1]), :agent)
      end
    end

    def can?(action)
      dispatched_method = Policy::Support.underscore(agent.class.name.split('::')[-1])
      send("#{dispatched_method}_can?", action)
    end
  end
end
