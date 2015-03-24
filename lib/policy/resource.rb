module Policy
  module Resource
    def policy_for(agent)
      Policy::Resolver.policy_for(self).new(agent, self)
    end
  end
end
