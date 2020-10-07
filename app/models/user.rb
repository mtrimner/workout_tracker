class User < ActiveRecord::Base

has_secure_password

has_many :workouts

validates :name, :email, :password, presence: true
  validates :email, uniqueness: true
end