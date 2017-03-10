# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'pranav@appstreet.io', password: 'password', password_confirmation: 'password', role: 'super_admin')
AdminUser.create!(email: 'mn@contecglobal.com', password: 'password', password_confirmation: 'password', role: 'super_admin')
unless Rails.env.production?
  Agent.create!(phone: '9716640632', lga: 'Egor')
  Batch.generate([{count: 10, amount: 1000}], false)
end
