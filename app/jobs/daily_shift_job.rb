class DailyShiftJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "⏰ Running DailyShiftJob..."

    now = DateTime.now
    start_time = now.tomorrow.beginning_of_day
    end_time = now.tomorrow.end_of_day

    User.find_each do |user|
    shifts = Shift.where(user: user, date: start_time..end_time)
    Rails.logger.info "📌 Found #{shifts.count} upcoming shifts"

    shifts.each do |shift|
      ShiftMailer.shift_reminder(shift, user).deliver_now
    end
  end

  end
end
