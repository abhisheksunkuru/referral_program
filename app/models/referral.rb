class Referral < ApplicationRecord
  enum :status, {pending: 0,accepted: 1}
  belongs_to :admin


end
