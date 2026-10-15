class LeaveRequest < ApplicationRecord
  belongs_to :employee

  validates :start_date, presence: true, on: :create, format: {
  with: /\A\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01])\z/,
  message: "must be in YYYY-MM-DD format (e.g., 2026-10-20)"
}
  validates :end_date, presence: true, on: :create ,format: {
  with: /\A\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01])\z/,
  message: "must be in YYYY-MM-DD format (e.g., 2026-10-20)"
}
  validates :status, presence: true , inclusion: { 
  in: %w[approved rejected pending], 
  message: "must enter either approved or rejected" 
  }
end