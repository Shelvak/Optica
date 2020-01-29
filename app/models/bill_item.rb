class BillItem < ApplicationRecord
  belongs_to :bill

  validates :description, :amount, :quantity, presence: true

  def total_amount
    (quantity || 0) * (amount || 0.0)
  end

  def sub_net_amount
    (total_amount / (1 + bill.vat / 100.0)).round(3)
  end
end
