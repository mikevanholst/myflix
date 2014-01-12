class User < ActiveRecord::Base

  validates_presence_of :email, :password, :full_name



  has_secure_password
end
