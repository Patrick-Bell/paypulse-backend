class Shift < ApplicationRecord

    belongs_to :user
    has_many :expenses, dependent: :destroy
    accepts_nested_attributes_for :expenses, allow_destroy: true

    
    before_create :calculate_hours_and_pay
    before_update :calculate_hours_and_pay
  
    def calculate_hours_and_pay
      return if start_time.nil? || finish_time.nil?
  
      finish_time_adjusted = finish_time < start_time ? finish_time + 1.day : finish_time
      self.hours = ((finish_time_adjusted - start_time) / 1.hour).round(2)
  
      return if rate.nil?
      self.pay = (rate * hours).round(2)
    end
  end
  