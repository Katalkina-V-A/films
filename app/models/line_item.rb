class LineItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :cart
  belongs_to :order

  def total_price
    book.price * quantity
  end
  def self.edit_by?(u)
    u.try(:admin?)
  end
end
