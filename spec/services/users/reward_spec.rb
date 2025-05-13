require 'rails_helper'

RSpec.describe Users::Reward do
  describe '.calculate_points' do
    context 'when referral_count is 10 or below' do
      it 'returns 10 points' do
        user = instance_double('User', referral_count: 5)
        expect(Users::Reward.calculate_points(user)).to eq(10)

        user = instance_double('User', referral_count: 10)
        expect(Users::Reward.calculate_points(user)).to eq(10)
      end
    end

    context 'when referral_count is between 11 and 20' do
      it 'returns 20 points' do
        user = instance_double('User', referral_count: 11)
        expect(Users::Reward.calculate_points(user)).to eq(20)

        user = instance_double('User', referral_count: 15)
        expect(Users::Reward.calculate_points(user)).to eq(20)

        user = instance_double('User', referral_count: 20)
        expect(Users::Reward.calculate_points(user)).to eq(20)
      end
    end

    context 'when referral_count is between 21 and 50' do
      it 'returns 30 points' do
        user = instance_double('User', referral_count: 21)
        expect(Users::Reward.calculate_points(user)).to eq(30)

        user = instance_double('User', referral_count: 35)
        expect(Users::Reward.calculate_points(user)).to eq(30)

        user = instance_double('User', referral_count: 50)
        expect(Users::Reward.calculate_points(user)).to eq(30)
      end
    end

    context 'when referral_count is 51 or above' do
      it 'returns 40 points' do
        user = instance_double('User', referral_count: 51)
        expect(Users::Reward.calculate_points(user)).to eq(40)

        user = instance_double('User', referral_count: 100)
        expect(Users::Reward.calculate_points(user)).to eq(40)
      end
    end
  end
end
