class Employee < ApplicationRecord
  belongs_to :department
  has_many :leave_requests, dependent: :destroy
  has_many :attendances, dependent: :destroy

  has_secure_password

  validates :name, presence: true, format: {
     with: /\A[A-Z][A-Za-z]*(?: [A-Za-z]+)*\z/,
     message: "can contain starting letter capital and only letters and spaces"
   }
  validates :email, presence: true, uniqueness: true, format: {
    with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/,
    message: "must enter valid email address"
  }
  validates :password, presence: true, on: :create, format: {
    with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}\z/,
    message: "must be at least 8 characters and contain uppercase, lowercase, number, and symbol"
  }
  validates :role, presence: true , inclusion: { 
  in: %w[hr employee], 
  message: "must enter either hr or employee" 
  }
  
end