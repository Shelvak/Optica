class BillItem < ApplicationRecord
  belongs_to :bill

  validates :description, :amount, presence: true
end
