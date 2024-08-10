require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'is valid with a unique username' do
      user = User.new(username: 'unique_user', email: 'unique@example.com', password: 'password123')
      expect(user).to be_valid
    end

    it 'is invalid without a username' do
      user = User.new(username: nil, email: 'test@example.com', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'is invalid with a non-unique username' do
      User.create!(username: 'duplicate_user', email: 'first@example.com', password: 'password123')
      user = User.new(username: 'duplicate_user', email: 'second@example.com', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("has already been taken")
    end

    it 'is valid with a unique email' do
      user = User.new(username: 'user1', email: 'unique@example.com', password: 'password123')
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(username: 'user1', email: nil, password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a non-unique email' do
      User.create!(username: 'user1', email: 'duplicate@example.com', password: 'password123')
      user = User.new(username: 'user2', email: 'duplicate@example.com', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end
  end

  describe 'Role Methods' do
    let(:admin_user) { User.create!(username: 'admin', email: 'admin@example.com', password: 'password123', role: 'admin') }
    let(:teacher_user) { User.create!(username: 'teacher', email: 'teacher@example.com', password: 'password123', role: 'teacher') }

    it 'returns true for admin? if role is admin' do
      expect(admin_user.admin?).to be(true)
    end

    it 'returns false for admin? if role is not admin' do
      expect(teacher_user.admin?).to be(false)
    end

    it 'returns true for teacher? if role is teacher' do
      expect(teacher_user.teacher?).to be(true)
    end

    it 'returns false for teacher? if role is not teacher' do
      expect(admin_user.teacher?).to be(false)
    end
  end

  describe '.find_for_database_authentication' do
    let!(:user) { User.create!(username: 'test_user', email: 'test@example.com', password: 'password123') }

    it 'finds a user by username' do
      found_user = User.find_for_database_authentication(login: 'test_user')
      expect(found_user).to eq(user)
    end

    it 'finds a user by email' do
      found_user = User.find_for_database_authentication(login: 'test@example.com')
      expect(found_user).to eq(user)
    end

    it 'returns nil if user is not found' do
      found_user = User.find_for_database_authentication(login: 'nonexistent_user')
      expect(found_user).to be_nil
    end
  end
end
