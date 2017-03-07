ActiveAdmin.register Agent do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
actions :bulk, :index, :new, :create
permit_params :phone, :name, :address, :birthplace, :state, :lga
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
index do
  if params[:error_no_array]
    div do
      render 'error_form', { error_no_array: params[:error_no_array] }
    end
  end
  id_column
  column :name
  column :phone
  column :address
  column :birthplace
  column :state
  column :lga
  column :created_at
  actions
end

action_item only: :index, method: :post do
  link_to 'Create agents', admin_agents_bulk_path
end


  form do |f|
  f.inputs "" do
    f.input :phone
    f.input :name
    f.input :address
    f.input :birthplace
    f.input :state, collection: JSON.parse(ENV["APP_CONFIG"])['states'], prompt: 'Please select'
    f.input :lga, :label => "LGA", collection: JSON.parse(ENV["APP_CONFIG"])['lga'], prompt: 'Please select'
  end
  f.actions
  end


  controller do

    def bulk

    end

    def bulk_creation
      phone_arr = params[:agents][:count].reject(&:blank?)
      phone_arr = phone_arr.uniq
      tmp_arr =[]
      @error_no_array = []
      phone_arr.each do |phone|
        agent = Agent.find_by(phone: "234#{phone}")
        if agent.nil?
          tmp_arr<< {phone: "234#{phone}"}
        else
          @error_no_array << phone
        end

      end

      Agent.create!(tmp_arr)
      redirect_to admin_agents_path("error_no_array"=> @error_no_array)
    end

    def active_admin_collection
      super.accessible_by current_ability
    end
    # include ActiveAdminCanCan
  end

end
