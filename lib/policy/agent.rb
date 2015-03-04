module Policy
  module Agent
    def can?(verb, resource)
      resource.policy_for(self).can?(verb)
    end
  end
end
