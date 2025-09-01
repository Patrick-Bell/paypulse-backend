class PayslipMailer < ApplicationMailer

    def payslip_reminder(user)
        @user = user

        mail(
            to: @user.email,
            subject: "Payslip Reminder"
        )
    end

    def generate_payslip_email(payslip, user)
        @payslip = payslip
        @user = user

        Rails.logger.info "✅ Sending payslip email to #{@user.email} for #{@user.first_name}"

        mail(to: @user.email, subject: 'Your Payslip is Ready')
    end

end
