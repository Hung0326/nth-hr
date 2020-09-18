# frozen_string_literal: true

class PasswordsController < Devise::PasswordsController
  def new
    super
  end

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      helpers.render_errors(resource)
      respond_with(resource) { |format| format.html { redirect_to new_password_path(resource) } }
    end
  end
end
