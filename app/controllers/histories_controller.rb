# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    histories = current_user.histories.order(created_at: :desc)
    @jobs = histories.map(&:job)
  end
end
