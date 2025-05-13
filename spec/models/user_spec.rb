# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(name: 'Test User', email: 'test@example.com', referral_code: 'ABCD1234')
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user = User.new(email: 'test@example.com', referral_code: 'ABCD1234')
      expect(user).not_to be_valid
    end

    it 'is not valid without an email' do
      user = User.new(name: 'Test User', referral_code: 'ABCD1234')
      expect(user).not_to be_valid
    end

    it 'is not valid without a referral code' do
      user = User.new(name: 'Test User', email: 'test@example.com')
      expect(user).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      User.create(name: 'Test User', email: 'test@example.com', referral_code: 'ABCD1234')
      user = User.new(name: 'Another User', email: 'test@example.com', referral_code: 'EFGH5678')
      expect(user).not_to be_valid
    end

    it 'is not valid with a duplicate referral code' do
      User.create(name: 'Test User', email: 'test@example.com', referral_code: 'ABCD1234')
      user = User.new(name: 'Another User', email: 'another@example.com', referral_code: 'ABCD1234')
      expect(user).not_to be_valid
    end
  end

  describe 'associations' do
    it 'can have many referrals' do
      referrer = User.create(name: 'Referrer', email: 'referrer@example.com', referral_code: 'ABCD1234')
      referred = User.create(name: 'Referred', email: 'referred@example.com', referral_code: 'EFGH5678', referred_by: referrer)

      expect(referrer.referrals).to include(referred)
    end

    it 'can be referred by another user' do
      referrer = User.create(name: 'Referrer', email: 'referrer@example.com', referral_code: 'ABCD1234')
      referred = User.create(name: 'Referred', email: 'referred@example.com', referral_code: 'EFGH5678', referred_by: referrer)

      expect(referred.referred_by).to eq(referrer)
    end
  end
end
