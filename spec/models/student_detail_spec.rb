require 'rails_helper'

RSpec.describe StudentDetail, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      student_detail = StudentDetail.new(name: 'John Doe', subject: 'Mathematics', mark: 85)
      expect(student_detail).to be_valid
    end

    it 'is invalid without a name' do
      student_detail = StudentDetail.new(name: nil, subject: 'Mathematics', mark: 85)
      expect(student_detail).not_to be_valid
      expect(student_detail.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a subject' do
      student_detail = StudentDetail.new(name: 'John Doe', subject: nil, mark: 85)
      expect(student_detail).not_to be_valid
      expect(student_detail.errors[:subject]).to include("can't be blank")
    end

    it 'is invalid without a mark' do
      student_detail = StudentDetail.new(name: 'John Doe', subject: 'Mathematics', mark: nil)
      expect(student_detail).not_to be_valid
      expect(student_detail.errors[:mark]).to include("can't be blank")
    end

    it 'is invalid with a non-numeric mark' do
      student_detail = StudentDetail.new(name: 'John Doe', subject: 'Mathematics', mark: 'A')
      expect(student_detail).not_to be_valid
      expect(student_detail.errors[:mark]).to include("is not a number")
    end

    it 'is invalid with a mark below 0' do
      student_detail = StudentDetail.new(name: 'John Doe', subject: 'Mathematics', mark: -5)
      expect(student_detail).not_to be_valid
      expect(student_detail.errors[:mark]).to include("must be greater than or equal to 0")
    end

  end
end
