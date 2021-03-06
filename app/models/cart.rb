class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :line_items, dependent: :destroy

  def add_book(book_id)
    current_item = line_items.find_by(book_id: book_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(book_id: book_id)
      current_item.price = current_item.book.price
    end
    current_item
  end

  def self.edit_by?(u)
    u.try(:admin?)
  end

  def self.edit_cart_by?(cart, current_cart)
    cart == current_cart
  end

  def total_price
    line_items.to_a.sum{|item| item.total_price}
  end
end
