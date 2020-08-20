# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  
  def after_inactive_sign_up_path_for(resource)
    confirm_sign_up_path(code: 2)
  end

  def after_update_path_for(resource)
    my_page_path
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
end
