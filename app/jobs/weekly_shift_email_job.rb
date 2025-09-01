class WeeklyShiftEmailJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      last_week_shifts = user.shifts.where(date: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
      two_weeks_ago_shifts = user.shifts.where(date: 2.weeks.ago.beginning_of_week..2.weeks.ago.end_of_week)

      if last_week_shifts.any?
        ShiftMailer.weekly_shift(last_week_shifts, two_weeks_ago_shifts, user).deliver_now
      else
        Rails.logger.info "No shifts found for user #{user.email} this week."
      end
    end
  end
end
