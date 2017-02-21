class AddRoleToAdminUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :admin_users, :role, :string

    AdminUser.create do |u|
    	u.email = 'admin@admin.com'
    	u.password = 'adminadmin'
    	u.password_confirmation = 'adminadmin'
    	u.role = 'admin'
    end	
  end
end
