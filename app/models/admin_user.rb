class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
  :recoverable, :rememberable, :trackable, :validatable

  ADMIN  = 'admin'
  SUPER  = 'super_admin'
  GUEST = 'guest'
  USER_ROLE = [SUPER, ADMIN, GUEST]
  USER_ROLE_HUMANIZED = {'Super Administrator' => SUPER, 'Administrator' => ADMIN, 'Guest User' => GUEST}

  validates_inclusion_of :role, :in => USER_ROLE

  validates :role, presence: true

end
