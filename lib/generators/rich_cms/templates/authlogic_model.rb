class <%= model_class_name %> < ActiveRecord::Base

  acts_as_authentic do |c|
    c.login_field            = :email
    c.crypted_password_field = :crypted_password
  end

end
