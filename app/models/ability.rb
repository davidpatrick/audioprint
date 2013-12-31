class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :read, [Album, Song, BlogPost]
    cannot :read, MixTape
    can :manage, Order, user_id: nil
    can :manage, OrderItem, order: {user_id: nil}

    if user.has_role? :admin
      can :admin, :all
      can :manage, :all
      can :create, :all
      can :read, :all
    end

    if user.has_role? :vendor
      can :read, MixTape
    end

    if user.persisted?
      can :create, Address
      can :destroy, Address, user_id: user.id
      can :manage, Order, user_id: user.id
      can :manage, OrderItem, order: {user_id: user.id}
    else
      can :create, Order
      can :create, OrderItem
    end

    # if user.has_role? :contributor
    #   can :create, [Album, Song]
    #   can :manage, Album, :user_id => user.id
    #   can :manage, Song, :album => { :user_id => user.id}
    # end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
