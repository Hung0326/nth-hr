# frozen_string_literal: true

# Industry controller
class IndustryController < ApplicationController
  def index
    @industries = Industry.all
  end
end
