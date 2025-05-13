# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :referred_by, class_name: "User", optional: true

  has_many :referrals, class_name: "User", foreign_key: "referred_by_id"

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :referral_code, presence: true, uniqueness: true
end
