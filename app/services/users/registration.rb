# frozen_string_literal: true

module Users
  class Registration
    attr_reader :params, :user

    def initialize(params)
      @params = params
    end

    def register
      @user = User.new(user_params)
      generate_unique_referral_code

      process_referral if params[:referral_code].present?

      if @user.save
        reward_referrer if @user.referred_by_id?
        true
      else
        false
      end
    end

    private

    def user_params
      params.except(:referral_code)
    end

    def generate_unique_referral_code
      loop do
        @user.referral_code = SecureRandom.alphanumeric(8).upcase
        break unless User.exists?(referral_code: @user.referral_code)
      end
    end

    def process_referral
      referrer = User.find_by_referral_code(params[:referral_code])
      @user.referred_by = referrer if referrer
    end

    def reward_referrer
      ActiveRecord::Base.transaction do
        @user.referred_by.increment!(:referral_count)
        @user.referred_by.increment!(
          :reward_points,
          Users::Reward.calculate_points(@user.referred_by)
        )
      end
    end
  end
end
