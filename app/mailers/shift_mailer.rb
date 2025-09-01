class ShiftMailer < ApplicationMailer

    def shift_added(shift)
      @shift = shift
  
      mail(
        to: ENV['EMAIL'], # Use the environment variable for the email address
        subject: 'New Shift Added'
      )
    end
  
    def shift_reminder(shift, user)
      @shift = shift
      @user = user
  
      mail(
        to: @user.email,
        subject: 'Shift Reminder'
      )
    end

    def weekly_shift(last_week_shifts, two_weeks_ago_shifts, user)
      @last_week_shifts = last_week_shifts
      @two_weeks_ago_shifts = two_weeks_ago_shifts
      @last_monday = 1.week.ago.beginning_of_week
      @last_sunday = 1.week.ago.end_of_week
      @user = user

      #Shift Counts
      @last_week_shifts_count = @last_week_shifts.count
      @two_weeks_ago_shifts_count = @two_weeks_ago_shifts.count
      @two_weeks_ago_monday = 2.weeks.ago.beginning_of_week
      @two_weeks_ago_sunday = 2.weeks.ago.end_of_week
      @shift_difference = @last_week_shifts_count - @two_weeks_ago_shifts_count

      #Shift Pay
      @last_week_pay = @last_week_shifts.sum(:pay)
      @two_weeks_ago_pay = @two_weeks_ago_shifts.sum(:pay)
      @pay_difference = @last_week_pay - @two_weeks_ago_pay

      #Shift Hours
      @last_week_hours = @last_week_shifts.sum(:hours)
      @two_weeks_ago_hours = @two_weeks_ago_shifts.sum(:hours)
      @hours_difference = @last_week_hours - @two_weeks_ago_hours
  
      mail(
        to: @user.email,
        subject: 'Weekly Shift Summary'
      )
    end




    def monthly_summary(shifts, user)
      @shifts = shifts
      @user = user
      @start_month = 1.month.ago.beginning_of_month.strftime("%B %d %Y")
      @finish_month = 1.month.ago.end_of_month.strftime("%B %d %Y")
      @month = 1.month.ago.strftime("%B")

      @pay = @shifts.sum(:pay)
      @hours = @shifts.sum(:hours)
      @shift_count = @shifts.count
      @average_pay = @pay / @shift_count if @shift_count > 0
      @average_hours = @hours / @shift_count if @shift_count > 0


      @locations = @shifts.group(:location).count
      @companies = @shifts.group(:company).count

      @payslip_reminder_text = 'Please ensure your shifts are up to date before the payslip is generated tomorrow at 12pm. This means ensuring that shifts are correctly marked as completed if you have finished them, and that any shifts you have worked are added to the system.'


      
      Rails.logger.info "Locations: #{@locations.inspect}"

      mail(to: @user.email, subject: 'Monthly Summary')
  end

end
  