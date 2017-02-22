class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
  :recoverable, :rememberable, :trackable, :validatable

  USER_ROLE = ['admin', 'super_admin']

  validates_inclusion_of :role, :in => USER_ROLE, :allow_nil => false

  validates :role, presence: true

end
