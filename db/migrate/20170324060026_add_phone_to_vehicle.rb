class AddPhoneToVehicle < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :phone, :string
    Vehicle.where.not("individual_id is NULL").find_each do |v|
      v.phone = v.individual.try(:phone)
      v.save!
    end
  end
end
