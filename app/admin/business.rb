ActiveAdmin.register Business do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :address, :turnover, :year, :lga, :individual_id, :name

filter :name
filter :lga

index do
  id_column
  column :name
  column :address
  column :turnover
  column :year
  column :uuid
  column :lga
  column :created_at, :class => 'col-created_at time'
  actions
end 
    
form do |f|
  f.inputs "" do
    f.input :individual, prompt: 'Please select'
    f.input :name
    f.input :address
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
