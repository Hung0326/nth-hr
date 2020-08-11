class RegistrationsController < Devise::RegistrationsController
  
  def after_inactive_sign_up_path_for(resource)
    confirm_sign_up_path(code: 2)
  end
end
