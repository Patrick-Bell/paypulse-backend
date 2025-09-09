class User < ApplicationRecord

    before_create :confirm_unique_email

    has_secure_password
    has_many :shifts
    has_many :contacts
    has_many :goals
    has_many :payslips
    has_many :expenses, through: :shifts
    has_many :reports

    validates :email, uniqueness: { message: "This email is already registered" }

end
