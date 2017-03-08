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

filter :name
filter :phone
filter :state

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
    f.input :phone, :input_html => { :class => 'phone_valid', :type => "number"  }
    f.input :name
    f.input :address
    f.input :birthplace
    f.input :state, collection: JSON.parse(ENV["APP_CONFIG"])['states'], prompt: 'Please select'
    f.input :lga, :label => "LGA", collection: JSON.parse(ENV["APP_CONFIG"])['lga'], prompt: 'Please select'
  end
    f.actions do
      f.action :submit, :wrapper_html => { :class => 'submit_valid'}
      f.action :cancel, :wrapper_html => { :class => 'cancel'}
    end
  end


  controller do

    def bulk

    end

    def bulk_creation
      phone = params[:phone].split(',')
      phone_arr = phone.reject(&:blank?)
      phone_arr = phone_arr.uniq
      tmp_arr =[]
      @error_no_array = []
      phone_arr.each do |number|
        if (number.length > 11) || (number.length == 11 && number[0] != '0') || (number.length < 10) || (number.length == 10 && number[0] == '0')
          @error_no_array << number
        else
          last_ten_digit_phone = number.last(10)
          agent = Agent.find_by(phone: "234#{last_ten_digit_phone}")
          if agent.nil?
            new_agent = Agent.new(phone: "234#{last_ten_digit_phone}")
            if new_agent.valid?
              tmp_arr<< {phone: number}
            else
              @error_no_array << number
            end
          else
            @error_no_array << number
          end
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
