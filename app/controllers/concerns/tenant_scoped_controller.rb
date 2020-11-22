module TenantScopedController
  extend ActiveSupport::Concern

  included do
    before_action :set_tenant
  end

  def set_tenant
    @tenant = Tenant.where(id: params[:tenant_id]) if params[:tenant_id]
  end

end