class StudentDetail < ApplicationRecord
  validates :name, presence: true
  validates :subject, presence: true
  validates :mark, presence: true
end