class GeneratePayslipJob < ApplicationJob
  queue_as :default

  def perform
    current_date = Date.current.prev_month
    month = current_date.strftime('%B')
    year = current_date.year

    start_of_month = current_date.beginning_of_month.beginning_of_day
    end_of_month = current_date.end_of_month.end_of_day

    User.find_each do |user|
      shifts = Shift.where(user: user, date: start_of_month..end_of_month, status: 'complete')
      total_pay = shifts.sum(:pay)

      payslip = Payslip.new(
        name: "#{month}-#{year}",
        month: month,
        year: year,
        gross: total_pay,
        net: total_pay * 0.8,
        hours: shifts.sum(:hours),
        tax: total_pay * 0.2,
        shifts: shifts.size,
        rate: shifts.average(:rate).to_i,
        status: 'complete',
        start: start_of_month.strftime('%B %-d'),
        finish: end_of_month.strftime('%B %-d'),
        year_gross: Payslip.where(user: user, year: year).sum(:gross) + total_pay,
        year_net: Payslip.where(user: user, year: year).sum(:net) + (total_pay * 0.8),
        year_tax: Payslip.where(user: user, year: year).sum(:tax) + (total_pay * 0.2),
        user: user,
        username: "#{user.first_name} #{user.last_name}"
      )

      if payslip.save
        Rails.logger.info "✅ Payslip for #{user.email} #{month} #{year} generated successfully"
        Rails.logger.info "Payslip user is #{payslip.user.email} with name #{payslip.username}"
        PayslipMailer.generate_payslip_email(payslip, user).deliver_now
      else
        Rails.logger.error "❌ Failed to generate payslip for #{user.email}: #{payslip.errors.full_messages.join(', ')}"
      end
    end
  end
end
