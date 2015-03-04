# Policy

Policy is a simple library to manage policy strategies for different "resources" which are operated on by one or more
"agents".

## Features

* No external dependencies
* Lightweight
* Pure and plain Ruby
* Does not hook into your framework
* Does not do the real work for you

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'policy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install policy

## Usage

An "agent" is some entity (e.g. a User) that may perform one or more actions on a "resource".
Each resource can have a policy associated to it, which is resolved at runtime. The default resolver walks up
the resource's ancestor chain and searches for an appropriate policy class, stopping at Object. If it does
not find a policy class, it returns the default policy (which is configured with ```Policy::Resolver.default_policy```).

A policy class can explicitly specify one or more agent types (via the ```allow_agents``` class method); in this case
the agent is checked at the moment of initialization.

An agent entity must include the ```Policy::Agent``` mix-in; this adds the ```can?(action, resource)``` instance method.

A resource entity must include the ```Policy::Resource``` mix-in; this adds the ```policy_for(agent)``` instance method.

The provided ```Policy::RoleBasedPolicy``` class implements a simple role-based policy which stores the permissions
in a YAML file. It assumes that the agent responds to the ```role``` instance method.
Example:

```ruby
class MyResourcePolicy < Policy::RoleBasedPolicy
  allow_agents MyAgent

  def allowed_actions
    [:create, :read]
  end
end

class MyAgent
  include Policy::Agent

  attr_accessor :role
end

```

in ```#{Policy::RoleBasedPolicy.policy_definitions_root}/my_resource.yml```:

```yaml
defaults: &DEFAULTS
  create: false
  read: true

admin:
  <<: *DEFAULTS
  create: true
```

Note: the ```defaults``` key is mandatory.

A policy instance can expose all its capabilities (what this agent can do with this resource) via the ```capabilities```
method. The default implementation simply iterates over all the ```allowed_actions``` and returns a Hash in the form
```{action: flag, ...}```.

The ```Policy::MultiAgentSupport``` mix-in is a simple helper to manage a policy which accepts multiple types of agents.
It adds a default ```can?``` implementation which delegates to an instance method named ```#{agent_type}_can?```,
where _agent_type_ is derived from the agent's class. It also defines an alias method for each _agent_type_ over the
```agent``` accessor.

Example:

```ruby
class FooPolicy
  allow_agents User, Guest
  include Policy::MultiAgentSupport

  def user_can?(action)
    user.role == 'admin'
  end

  def guest_can?(action)
    guest.name == 'Chuck Norris' # Chuck Norris always can.
  end
end
```

Note that you must include ```Policy::MultiAgentSupport``` _after_ ```allow_agents```.

## Contributing

1. Fork it ( https://github.com/stefanoc/policy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
