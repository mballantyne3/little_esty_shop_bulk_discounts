class Invoice < ApplicationRecord
  validates_presence_of :status,
    :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    # invoice_items.distinct("invoice_items.id").left_joins(:bulk_discounts).sum do |ii|
    #   best_bulk_discount = ii.bulk_discounts
    #     .where("qty_threshold <= #{ii.quantity}")
    #     .maximum(:percent_discount) || 0
    #
    #   ii.unit_price * ii.quantity * (1.0 - best_bulk_discount / 100.0)
    # end

    total_revenue - invoice_items
      .select('MAX(quantity * invoice_items.unit_price * percent_discount / 100) AS best_discount')
      .left_joins(:bulk_discounts)
      .where("quantity >= qty_threshold")
      .group(:id)
      .sum(&:best_discount)
  end
end
