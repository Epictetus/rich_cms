class Auth::Devise::User < ActiveRecord::Base
  set_table_name :auth_devise_users
  # devise :database_authenticatable
end