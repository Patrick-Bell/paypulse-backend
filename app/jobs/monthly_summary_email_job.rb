class MonthlySummaryEmailJob < ApplicationJob
  queue_as :default

  def perform()
    User.find_each do |user|
      start_month = 1.month.ago.beginning_of_month
      finish_month = 1.month.ago.end_of_month

      shifts = user.shifts.where(date: start_month..finish_month)

      ShiftMailer.monthly_summary(shifts, user).deliver_now


    end
  end


end
