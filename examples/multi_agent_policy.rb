require 'policy'

class Widget < Struct.new(:name)
  include Policy::Resource

  def to_s
    name
  end
end

class Guest
  include Policy::Agent

  def to_s
    'Guest'
  end
end

class User < Struct.new(:login, :permissions)
  include Policy::Agent

  def to_s
    "User[#{login}]"
  end
end

class WidgetPolicy < Policy::Base
  allow_agents Guest, User
  include Policy::MultiAgentSupport

  def guest_can?(action)
    action == :touch
  end

  def user_can?(action)
    action == :touch || user.permissions.include?(action)
  end

  def allowed_actions
    [:touch, :push]
  end
end

if __FILE__ == $0
  guest = Guest.new
  joe   = User.new('joe_nobody', [])
  chuck = User.new('chuck_n', [:push])
  thing = Widget.new('a thing')
  test  = ->(who, what) { puts "#{who} #{who.can?(what, thing) ? 'can' : 'cannot'} #{what} #{thing}" }
  test.(guest, :touch)
  test.(guest, :push)
  test.(joe, :push)
  test.(chuck, :push)
end
