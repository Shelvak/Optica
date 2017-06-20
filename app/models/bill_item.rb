class BillItem < ApplicationRecord
  belongs_to :bill

  validates :description, :amount, :quantity, presence: true

  def total_amount
    (quantity || 0) * (amount || 0.0)
  end
end
