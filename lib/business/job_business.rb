# frozen_string_literal: true

class JobBusiness
  def self.add_job_to_history(job_id, current_user)
    current_user.histories.find_or_create_by(job_id: job_id)
    counter_history = current_user.histories.count
    current_user.histories.destroy(current_user.histories.first) if counter_history > History::NUMBER_JOB_LIMIT
  end
end
