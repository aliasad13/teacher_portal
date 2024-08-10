class StudentDetail < ApplicationRecord
  validates :name, presence: true
  validates :subject, presence: true
  validates :mark, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
end