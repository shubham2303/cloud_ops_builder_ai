class Ability
  include CanCan::Ability

  def initialize(user)
    role = user.role
    can :manage, ActiveAdmin::Page, :name => "Dashboard"
    case role
    when 'admin'
      can :manage, Agent
      can :manage, Individual
      can :manage, Business
      can :read, user
    when 'super_admin'
      can :manage, Agent
      can :manage, AdminUser
      cannot :destroy, user
      can :manage, Individual
      can :manage, Business
      can :manage, Batch
    when 'guest'
      can :read, Agent
      cannot [:bulk, :bulk_creation], Agent
      can :read, Individual
      can :read, Business
      can :read, user
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
