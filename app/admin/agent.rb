ActiveAdmin.register Agent do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  actions :bulk, :index, :new, :create, :edit, :destroy, :update, :show
  permit_params :phone, :first_name, :last_name, :address, :birthplace, :state, :lga, :beat_code
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
    column :lga
    column  "Revenue Beat", :beat_code do |obj|
      obj.revenue_beat
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :phone
      row :first_name
      row :last_name
      row :lga
      row "Revenue Beat", :beat_code  do |obj|
        obj.revenue_beat
      end
      row :address
      row :birthplace
      row :state
      row :dob
    end
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
      f.input :lga, :label => "LGA", collection: JSON.parse(ENV["APP_CONFIG"])['lga'],
              prompt: 'Please select', :input_html => {:class => 'lga'}
      lga = f.object.lga
      beat_list = []
      unless lga.nil?
        ApplicationHelper::AppConfig.beat_json[lga].each do |key, value|
          arr = [value, key]
          beat_list << arr
        end
      end
      f.input :beat_code, :as => :select, :label => "Revenue Beat", collection: beat_list, :input_html => {:class => 'beat_code'}, prompt: 'Please select'
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
        phone, lga, beat = a.split(/,\s*/)
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
        beat_list_hsh = ApplicationHelper::AppConfig.beat_json[lga]
        beat_list_val =  beat_list_hsh.values
        unless beat_list_val.include?(beat)
          flash.now[:error] = "Invalid beat '#{beat}' for '#{lga}' lga on line number #{index + 1}"
          render "admin/agents/bulk"
          return
        end
        beat_code = beat_list_hsh.key(beat)
        last_ten_digit_phone = phone.last(10)
        q +="('234#{last_ten_digit_phone}','#{lga}','#{beat_code}',now(), now()),"
      end

      if q.empty?
        flash.now[:error] = 'No Agents created'
        render "admin/agents/bulk"
        return
      end

      values = q.first(-1)
      ActiveRecord::Base.connection.execute "INSERT INTO agents (phone, lga, beat_code, created_at, updated_at) values"+values+ " ON CONFLICT DO NOTHING;"
      flash[:notice] = "#{phone_lga.count} Agents created"
      redirect_to admin_agents_path
    end

    def revenue_beats
      render json: ApplicationHelper::AppConfig.beat_json[params["lga"]]
    end

    def active_admin_collection
      super.accessible_by current_ability
    end
  end

end
