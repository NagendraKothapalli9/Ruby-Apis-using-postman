class Department < ApplicationRecord
  has_many :employees, dependent: :destroy

  validates :name, presence: true, uniqueness: true, format: {
     with: /\A[A-Z][A-Za-z]*(?: [A-Za-z]+)*\z/,
     message: "can contain starting letter capital and contain only letters and spaces"
   }
end