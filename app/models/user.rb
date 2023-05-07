class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :update_referral_status,unless: Proc.new{self.type == "Admin"}

  def referred_by
    if invited_by.present?
      user = User.where(id: invited_by).last
      user&.email
    end
  end

  private

  def update_referral_status
    begin
      referral = User.find(invited_by).referrals.where(email: self.email).last
      if referral.present?
        referral.update(status: "accepted")
      end
    rescue => e
      puts e.message
      puts e.backtrace
    end
  end
end
