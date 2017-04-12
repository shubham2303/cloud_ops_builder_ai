class RemoveSpacesFromVehicleNumber < ActiveRecord::Migration[5.0]
  def change
    Vehicle.all.each do |v|
      v.vehicle_number = v.vehicle_number.split.join
      v.save!
    end
  end
end
