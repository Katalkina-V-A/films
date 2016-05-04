class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  has_many :books, through: :line_items
  belongs_to :user
  validates :name, :address, :pay_type, :delivery_type, presence: true
  validates :email, presence: true,
            format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :name, length: {minimum: 2, maximum: 255}
  DELIVERIES = [["Доставка курьером", 0], ["Самовывоз", 1], ["Доставка почтой", 2]]
  PAIS = [["Наличными", 0], ["Картой", 1], ["Чеком", 2]]
  STATUSES = [["Ожидается оплата", 0], ["Заказ собирается", 1], ["В пути", 2], ["Вы можете забрать заказ", 3], ["Заказ завершен", 4], ["Заказ отменен", 5]]
  scope :ordering, -> {order(:name)}
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
  def self.edit_by?(u)
    u.try(:admin?)
  end
  def total_price
    line_items.to_a.sum{|item| item.total_price}
  end
end
