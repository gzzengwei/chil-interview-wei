# frozen_string_literal: true

module Users
  class Reward
    def self.calculate_points(user)
      return 10 if user.referral_count <= 10
      return 20 if user.referral_count <= 20
      return 30 if user.referral_count <= 50
      40
    end
  end
end
