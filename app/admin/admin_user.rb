ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :role

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    attributes_table :id, :email, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :last_sign_in_ip,
                     :last_sign_in_ip, :created_at, :updated_at, :role, :reset_password_sent_at, :remember_created_at
  end


  filter :email
  # filter :current_sign_in_at
  # filter :sign_in_count
  # filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :role, collection: AdminUser::USER_ROLE_HUMANIZED, prompt: 'Please select'
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
