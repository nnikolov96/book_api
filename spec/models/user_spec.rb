require 'rails_helper'

RSpec.describe User do
  let(:user) { FactoryBot.create(:user) }

  context 'validations' do
    it 'has a valid factory' do
      expect(user).to be_valid
    end

    context 'email' do
      it 'is not valid without email' do
        user.email = nil
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include "can't be blank"
      end

      it 'is not valid with email shorter than 5 characters' do
        user.email = 'test'
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include 'is too short (minimum is 5 characters)'
      end

      it 'is not valid with email longer than 120 characters' do
        user.email = 'T' * 121
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include 'is too long (maximum is 120 characters)'
      end
    end

    context 'password' do
      it 'is not valid without password' do
        user.password = nil
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include "can't be blank"
      end

      it 'is not valid with password shorter than 6 characters' do
        user.password = 'short'
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include 'is too short (minimum is 6 characters)'
      end

      it 'is not valid with password longer than 16 characters' do
        user.password = 'T' * 27
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include 'is too long (maximum is 26 characters)'
      end

      it 'is matching password and password confirmation' do
        user.password_confirmation = 'not matching'
        expect(user).to_not be_valid
        expect(user.errors[:password_confirmation]).to include "doesn't match Password"
      end
    end

    it 'has unique email' do
      user_dup = user.dup
      expect(user_dup).to_not be_valid
      expect(user_dup.errors[:email]).to include 'has already been taken'
    end
  end
end
