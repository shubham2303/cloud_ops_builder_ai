ActiveAdmin.register Agent do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  actions :bulk, :index, :new, :create, :edit, :destroy, :update, :show
  permit_params :phone, :first_name, :last_name, :address, :birthplace, :state, :lga
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  filter :first_name
  filter :last_name
  filter :phone
  filter :state

  index do
    id_column
    column :first_name
    column :last_name
    column :phone
    column :address
    column :birthplace
    column :state
    column :lga
    column :created_at, :class => 'col-created_at time'
    actions
  end

  action_item(:bulk, method: :post, only: :index) do
    link_to 'Bulk Create', admin_bulk_path if can?(:bulk, Agent)
  end

  collection_action :bulk, :title => "Create Bulk Agents" do
  end


  form do |f|
    f.inputs "" do
      phone = f.object.new_record? ? '' : f.object.phone.last(10)
      f.input :phone, :input_html => {:class => 'phone_valid', :type => "number", value: phone}
      f.input :first_name
      f.input :last_name
      f.input :address
      f.input :birthplace
      f.input :state, collection: JSON.parse(ENV["APP_CONFIG"])['states'], prompt: 'Please select'
      f.input :lga, :label => "LGA", collection: JSON.parse(ENV["APP_CONFIG"])['lga'], prompt: 'Please select'
    end
    f.actions do
      f.action :submit, :wrapper_html => {:class => 'submit_valid'}
      f.action :cancel, :wrapper_html => {:class => 'cancel'}
    end
  end


  controller do
    def bulk
      @error_csv_invalidate = nil
    end

    def bulk_creation
      q=""
      valid_lgas = ApplicationHelper::AppConfig.json['lga']
      phone_regex = /^(234|0)?[1-9]\d{9}$/
      phone_lga = params[:phone_lga].split(/[\r\n]+/)
      phone_lga.each_with_index do |a, index|
        phone, lga = a.split(/,\s*/)
        if phone_regex.match(phone).nil?
          flash.now[:error] = "Invalid phone number '#{phone}' on line number #{index + 1}"
          render "admin/agents/bulk"
          return
        end
        unless valid_lgas.include?(lga)
          flash.now[:error] = "Invalid LGA '#{lga}' on line number #{index + 1}"
          render "admin/agents/bulk"
          return
        end
        last_ten_digit_phone = phone.last(10)
        q +="('234#{last_ten_digit_phone}','#{lga}',now(), now()),"
      end

      if q.empty?
        flash.now[:error] = 'No Agents created'
        render "admin/agents/bulk"
        return
      end

      values = q.first(-1)
      ActiveRecord::Base.connection.execute "INSERT INTO agents (phone, lga, created_at, updated_at) values"+values+ " ON CONFLICT DO NOTHING;"
      flash[:notice] = "#{phone_lga.count} Agents created"
      redirect_to admin_agents_path
    end

    def active_admin_collection
      super.accessible_by current_ability
    end
  end

end
