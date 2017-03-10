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
  column :created_at
  actions
end

action_item(:index, method: :post) do
  link_to 'Bulk Agents', admin_bulk_path
end

collection_action :bulk, :title => "Create Bulk Agents" do
end


form do |f|
  f.inputs "" do
    phone = f.object.new_record? ? '' : f.object.phone.last(10)
    f.input :phone, :input_html => { :class => 'phone_valid', :type => "number", value: phone }
    f.input :first_name
    f.input :last_name
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
    @error_csv_invalidate = nil
  end

  def bulk_creation
    arr = []
    phone_lga = params[:phone_lga].split(/[\r\n]+/)
    phone_lga.each do |a|
      arr<< a.split(", ")
    end
    valid_csv_array = []
    arr.each do |a|
      unless a.size == 2
        flash.now[:error] = "csv invalidate"
        render "admin/agents/bulk"
        return
      else
        valid_csv_array << a
      end
    end
    @error_no_array = []
    q=""
    valid_csv_array.each do |a|

      if (a[0].length > 11) || (a[0].length == 11 && a[0][0] != '0') || (a[0].length < 10) || (a[0].length == 10 && a[0][0] == '0')
        @error_no_array << a[0]
      else
        last_ten_digit_phone = a[0].last(10)
        new_agent = Agent.new(phone: "234#{last_ten_digit_phone}", lga: a[1])
        if new_agent.valid?
          q +="('234#{a[0]}','#{a[1]}',now(), now()),"
        else
          @error_no_array << a[0]
        end
      end
    end
    unless q.empty?
      values = q.first(-1)
        # ActiveRecord::Base.connection.execute "INSERT INTO agents (phone, lga, created_at, updated_at) values"+values
        ActiveRecord::Base.connection.execute "INSERT INTO agents (phone, lga, created_at, updated_at) values"+values+ " ON CONFLICT DO NOTHING;"
    end
      unless @error_no_array.blank?
        flash[:error] = "#{@error_no_array.count} #{ (@error_no_array.count > 1) ? "numbers" : "number"} cannot saved.\n\nThese numbers cannot be saved --  #{@error_no_array.join(', ')}"
      end
      redirect_to admin_agents_path
    end

    def active_admin_collection
      super.accessible_by current_ability
    end
    # include ActiveAdminCanCan
  end

end
