ActiveAdmin.register Individual do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :phone, :name, :address
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
	id_column
	column :phone
	column :name
	column :address
	column :created_at
	column :uuid
	actions
end	

form do |f|
	f.inputs "Subscription Plan" do
		f.input :phone
		f.input :name
		f.input :address
	end
	f.actions
end

controller do
	def active_admin_collection
    super.accessible_by current_ability
  end
	# include ActiveAdminCanCan
end

end
