module Policy
  module Resource
    def policy_for(agent)
      Policy::Resolver[self].new(agent, self)
    end
  end
end
