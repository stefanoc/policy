module Policy
  module Agent
    def can?(verb, resource)
      resource.policy_for(self).can?(verb)
    end

    def can_all?(verb, resources)
      return true if resources.empty?
      policy = resources[0].policy_for(self)
      resources.all? { |resource| policy.recycle(resource).can?(verb) }
    end

    def all_it_can(verb, resources)
      return [] if resources.empty?
      policy = resources[0].policy_for(self)
      resources.find_all { |resource| policy.recycle(resource).can?(verb) }
    end
  end
end
