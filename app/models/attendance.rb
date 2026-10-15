class Attendance < ApplicationRecord
  belongs_to :employee
   
  validates :employee_id, presence: true, numericality: { only_integer: true }
  validate :employee_must_exist
  validates :date, presence: true, format: {
  with: /\A\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01])\z/,
  message: "must be in YYYY-MM-DD format (e.g., 2026-10-20)"
}
  validates :status, presence: true, inclusion: { 
  in: %w[present absent], 
  message: "must enter either present or absent" 
  }

  
  private

  def employee_must_exist
    if employee_id.present? && !Employee.exists?(employee_id)
      errors.add(:employee_id, "does not exist in the database")
    end
  end
end