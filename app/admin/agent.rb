ActiveAdmin.register Agent do
before_filter :authorize_this
# controller.authorize_resource
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

# controller do
	
# 	include ActiveAdminCanCan
# end	

	controller do
    # CanCanCan raises `CanCan::AuthorizationNotPerformed` because 
    # `@_authorized` is not defined in the controller's scope 
    # after this method call
    def authorize_this
      authorize! :create, Agent
    end
  end

end
