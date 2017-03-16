ActiveAdmin.register Vehicle do

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
  permit_params :vehicle_number, :lga, :individual_id

  filter :vehicle_number
  filter :lga

  index do
    id_column
    column :vehicle_number
    column :lga
    column :created_at
    actions
  end

  form do |f|
    f.inputs "" do
      f.input :individual, prompt: 'Please select'
      f.input :vehicle_number
      f.input :lga, :label => "LGA", collection: JSON.parse(ENV["APP_CONFIG"])['lga'], prompt: 'Please select'
    end
    f.actions
  end

end
