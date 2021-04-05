class Ability
  include CanCan::Ability

  def initialize(user)

    if user.present?

      can :manage, :all if user.is_super_user?

      if user.is_tenant_based?

        tenant_based_models = [Client, Booking, BookingRequest, Hotel, User]

        # This is if they are a client user
        can :manage, User do |u|
          u.client.try(:tenant).try(:id) == user.tenant_id
        end

        tenant_based_models.each do |m|
          can :manage, m do |a|
            a.tenant_id == user.tenant_id
          end

          can :new, m
          can :create, m
        end

        can :new_staff, User
        can :create_staff, User


      elsif user.is_client_based?
        # Nothing as of now

      end

      can :manage, :home
    end

  end

end
