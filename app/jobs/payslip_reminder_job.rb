class PayslipReminderJob < ApplicationJob
  queue_as :default

  def perform

    User.find_each do |user|
    PayslipMailer.payslip_reminder(user).deliver_now
    end

  end


end
