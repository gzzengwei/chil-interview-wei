require 'rails_helper'

RSpec.describe Users::Registration do
  describe '#register' do
    let(:user_params) { { name: 'Test User', email: 'test@example.com' } }

    it 'creates a new user' do
      service = Users::Registration.new(user_params)

      expect { service.register }.to change(User, :count).by(1)
    end

    it 'generates a unique referral code' do
      service = Users::Registration.new(user_params)
      service.register

      expect(service.user.referral_code).to be_present
      expect(service.user.referral_code.length).to eq(8)
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { name: '', email: 'test@example.com' } }

      it 'does not create a user' do
        service = Users::Registration.new(invalid_params)

        expect { service.register }.not_to change(User, :count)
      end

      it 'returns false' do
        service = Users::Registration.new(invalid_params)

        expect(service.register).to be_falsey
      end
    end

    context 'with referral code' do
      let!(:referrer) { User.create(name: 'Referrer', email: 'referrer@example.com', referral_code: 'ABCD1234') }

      it 'links the new user to the referrer' do
        service = Users::Registration.new(user_params.merge(referral_code: 'ABCD1234'))
        service.register

        expect(service.user.referred_by).to eq(referrer)
      end

      it 'increments the referrer\'s referral count' do
        service = Users::Registration.new(user_params.merge(referral_code: 'ABCD1234'))

        expect { service.register }.to change { referrer.reload.referral_count }.by(1)
      end

      it 'awards points to the referrer' do
        service = Users::Registration.new(user_params.merge(referral_code: 'ABCD1234'))

        expect { service.register }.to change { referrer.reload.reward_points }.by(Users::Registration::REWARD_POINTS_PER_REFERRAL)
      end

      it 'does not link to a referrer if code is invalid' do
        service = Users::Registration.new(user_params.merge(referral_code: 'INVALID'))
        service.register

        expect(service.user.referred_by).to be_nil
      end

      it 'generates a new unique referral code for the user, not using the referrer code' do
        service = Users::Registration.new(user_params.merge(referral_code: 'ABCD1234'))
        service.register

        expect(service.user.referral_code).to be_present
        expect(service.user.referral_code).not_to eq('ABCD1234')
      end


      context 'with referral code for an experienced referrer' do
        let!(:experienced_referrer) do
          User.create(
            name: 'Experienced Referrer',
            email: 'experienced@example.com',
            referral_code: 'EXPREF12',
            referral_count: 15,
            reward_points: 150
          )
        end

        it 'awards 20 points to referrers with 11-20 previous referrals' do
          service = Users::Registration.new({
            name: 'New Referred User',
            email: 'referred@example.com',
            referral_code: 'EXPREF12'
          })

          expect { service.register }.to change { experienced_referrer.reload.reward_points }.by(20)

          expect(experienced_referrer.reload.referral_count).to eq(16)

          expect(service.user.referred_by_id).to eq(experienced_referrer.id)
        end
      end
    end
  end
end
