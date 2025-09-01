Rails.application.routes.draw do
  
  scope 'api' do

    # Register Routes
    post 'register', to: 'register#register', as: 'register'
    post '/login', to: 'session#login', as: 'login'
    delete '/logout', to: 'session#logout', as: 'logout'
    
    # Shift Routes
    get 'month-shifts', to: 'shifts#month_shifts', as: 'month_shifts'
    get 'previous-month-shifts', to: 'shifts#previous_month_shifts', as: 'previous_month_shifts'
    get 'current-month-shifts', to: 'shifts#month_shifts', as: 'current_month_shifts'
    get 'shift-dates', to: 'shifts#shift_dates', as: 'shift_dates'
    get 'get-week-shifts', to: 'shifts#get_week_shifts', as: 'get_week_shifts'
    get 'shifts-by-date', to: 'shifts#shifts_by_date', as: 'shifts_by_date'
    get '/shifts/:id/calendar.ics', to: 'shifts#calendar_event', as: 'shift_calendar'

    # Contact Routes
    get 'download-contact/:id', to: 'contacts#download_contact', as: 'download_contact'

    # Payslip Routes
    get 'get-year-payslips/:id', to: 'payslips#get_year_payslips', as: 'get_year_payslips'
    post 'build-payslip', to: 'payslips#build_payslip', as: 'build_payslip'
    get 'payslip-shifts/:id', to: 'payslips#get_payslip_shifts', as: 'payslip_shifts'

    # User Routes
    get 'current-user', to: 'application#current_user', as: 'current_user'
    post 'change-password', to: 'users#change_password', as: 'change_password'

    # Chatbot Routes
    post 'ask-chatbot', to: 'chatbot#ask_chatbot', as: 'ask_chatbot'

    # Payment Routes
    post 'payment', to: 'payment#create_checkout_session', as: 'create_checkout_session'

    
    resources :payslips
    resources :shifts
    resources :contacts
    resources :goals
    resources :users
    resources :expenses

  end

end
