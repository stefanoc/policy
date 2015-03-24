module Policy
  class Resolver
    class <<self
      attr_accessor :default_policy

      def [](resource)
        default_resolver[resource]
      end

      def default_resolver
        @default_resolver ||= new(default_policy)
      end
    end

    def initialize(default_policy)
      @default_policy  = default_policy
      @cached_policies = {}
    end

    def find_policy(klass)
      @cached_policies[klass] ||= resolve_recursive(klass.ancestors)
    end

    def policy_for(resource)
      find_policy(resource.class)
    end

    private

    def resolve_recursive(path)
      if path[0] == Object
        @default_policy
      else
        name = policy_name_for(path[0])
        if name && (klass = find_policy_class(name))
          klass
        else
          resolve_recursive(path[1..-1])
        end
      end
    end

    def find_policy_class(name)
      Object.const_get(name)
    rescue NameError
      nil
    end

    def policy_name_for(klass)
      klass.name.gsub('::', '') + 'Policy' if klass.name
    end
  end
end
