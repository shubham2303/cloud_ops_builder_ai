ActiveAdmin.register Business do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :address, :category, :turnover, :year, :lga
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

    
form do |f|
  f.inputs "" do
    f.input :individual, prompt: 'Please select'
    f.input :address
    f.input :category
    f.input :turnover
    f.input :year
    f.input :lga, :label => "LGA", collection: JSON.parse(ENV["APP_CONFIG"])['lga'], prompt: 'Please select'
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
