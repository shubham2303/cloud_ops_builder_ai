ActiveAdmin.register Individual do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :phone, :first_name, :last_name, :address, :lga

filter :first_name
filter :last_name
filter :lga
filter :uuid
filter :phone


index do
	id_column
	column :phone
	column :first_name
	column :last_name
	column :address
	column :lga
	column :created_at do |obj|
		ApplicationHelper.local_time(obj.created_at)
	end
	column :uuid
	actions
end	

form do |f|
	f.inputs "Subscription Plan" do
		phone = f.object.new_record? ? '' : f.object.phone.last(10)
		f.input :phone, :input_html => { :class => 'phone_valid', :type => "number", value: phone}
		f.input :first_name
		f.input :last_name
		f.input :address
		f.input :lga, :label => "LGA", collection: JSON.parse(ENV["APP_CONFIG"])['lga'], prompt: 'Please select'
	end
	f.actions do
		f.action :submit#, :wrapper_html => { :class => 'submit_valid'}
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
