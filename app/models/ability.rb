class Ability
  include CanCan::Ability

  def initialize(user)

    if user.present?

      can :manage, :all if user.is_super_user?

      if user.is_tenant_based?
        can :manage, :clients
        can :manage, :users

      elsif user.is_client_based?
        # Nothing as of now

      end

      can :manage, :home
    end

  end

end
