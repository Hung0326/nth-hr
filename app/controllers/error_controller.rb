# frozen_string_literal: true

# Controller error
class ErrorController < ApplicationController
  def page_not_found; end

  def internal_server_error; end
end
