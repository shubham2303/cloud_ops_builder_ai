ActiveAdmin.register Individual do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :phone, :first_name, :last_name, :address

filter :first_name
filter :last_name
filter :lga
filter :uuid


index do
	id_column
	column :phone
	column :first_name
	column :last_name
	column :address
	column :created_at
	column :uuid
	actions
end	

form do |f|
	f.inputs "Subscription Plan" do
		f.input :phone, :input_html => { :class => 'phone_valid', :type => "number"  }
		f.input :first_name
		f.input :last_name
		f.input :address
	end
	f.actions do
		f.action :submit, :wrapper_html => { :class => 'submit_valid'}
		f.action :cancel, :wrapper_html => { :class => 'cancel'}
	end
end

controller do
	def active_admin_collection
    super.accessible_by current_ability
  end
	# include ActiveAdminCanCan
end

end
