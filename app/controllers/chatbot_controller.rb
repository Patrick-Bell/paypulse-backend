class ChatbotController < ApplicationController
  before_action :set_current_user

  require 'net/http'
  require 'json'

  def ask_chatbot
    question = params[:question]

    start = Date.current.beginning_of_month
    finish = Date.current.end_of_month

    shifts = Shift.where(user: @current_user, date: start..finish).order(date: :asc)

    today = Date.current

    past_shifts = shifts.where('date < ?', today)
    upcoming_shifts = shifts.where('date >= ?', today)    

    Rails.logger.info "Past Shifts #{past_shifts}"
    Rails.logger.info "Upcoming Shifts #{upcoming_shifts}"

    formatted_past = past_shifts.each_with_index.map do |shift, i|
      "Shift #{i + 1}: Date: #{shift.date}, Start Time: #{shift.start_time.strftime('%H:%M')}, Finish Time: #{shift.finish_time.strftime('%H:%M')}, Location: #{shift.location}, Hours: #{shift.hours}, Pay: #{shift.pay.round(2)}"
    end.join("\n")

    formatted_upcoming = upcoming_shifts.each_with_index.map do |shift, i|
      "Shift #{i + 1}: Date: #{shift.date}, Start Time: #{shift.start_time.strftime('%H:%M')}, Finish Time: #{shift.finish_time.strftime('%H:%M')}, Location: #{shift.location}, Hours: #{shift.hours}, Pay: #{shift.pay.round(2)}"
    end.join("\n")

    past_pay = past_shifts.sum(:pay).round(2)
    past_hours = past_shifts.sum(:hours).round(2)
    upcoming_pay = upcoming_shifts.sum(:pay).round(2)
    upcoming_hours = upcoming_shifts.sum(:hours).round(2)
    total_pay = shifts.sum(:pay).round(2)
    total_hours = shifts.sum(:hours).round(2)
    

    prompt = <<~PROMPT
      You are a helpful assistant that can answer questions about the user's shift schedule, all for #{Date.current.strftime('%B %Y')}.

      Today's date is #{today}.

      The user has completed the shifts below.
      #{formatted_past.presence || 'No past shifts.'}
      You have currently earned £#{past_pay}, working a total of #{past_hours} hours this month.

      The user still has these shifts to complete.
      #{formatted_upcoming.presence || 'No upcoming shifts.'}
      The user has a total of #{shifts.count} shifts this month with a total of #{upcoming_hours} hours and £#{upcoming_pay} pay upcoming.

      The user's total pay for this month is £#{total_pay}.
      The user's total hours worked this month is #{total_hours}.

      If the user asks about payslips, you should inform them that payslips are available in the Payslips section of the app, or mention that they are released on the 2nd of the following month, or to visit the FAQ page.
      If the user asks about account details, you should inform them that they can update their account details in the Account section of the app. If they have an issue they should contact support o paypulse@gmail.com

      The user has asked: "#{question}".

      Please use only the above data to answer clearly and accurately.
   PROMPT

  
  

    uri = URI('http://localhost:11434/api/generate')
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
    request.body = {
      model: 'mistral',
      prompt: prompt,
      stream: true
    }.to_json

    answer = ""

    http.request(request) do |response|
      response.read_body do |chunk|
        begin
          json = JSON.parse(chunk)
          answer << json["response"].to_s if json["response"]
        rescue JSON::ParserError
          # Ignore partial/malformed JSON in streamed chunks
        end
      end
    end

    render json: { answer: answer.presence || "No answer found." }

  rescue => e
    render json: { answer: "Error: #{e.message}" }
  end
end
