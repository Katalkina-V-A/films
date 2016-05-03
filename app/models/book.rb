class Book < ActiveRecord::Base
  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  has_attached_file :cover, styles: {medium: "250x250>", thumb: "100x100>"}

  has_and_belongs_to_many :films, -> { ordering.base }

  validates :title, :author, :publishing, :price, :year, :amount, presence: true
  validates :amount, numericality: {only_integer: true, greater_than: 0}, allow_blank: true
  validates :year, numericality: {only_integer: true, greater_than: 1885}, allow_blank: true
  validates :price, numericality: {greater_than_or_equal: 0.01}, allow_blank: true
  validates_attachment :cover, content_type: {content_type: /\Aimage\/.*\z/}

  # scope :ordering, -> { order(:title, :author, :publishing, :year, :price) }
  scope :ordering, -> {(order(:title))}

  def self.edit_by?(u)
    u.try(:admin?)
  end

  def can_destroy?
    films.blank?
  end

  def self.search(query)
    ordering.where("upper(title) like upper(:q)", q: "%#{query}%")
  end
  private
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errora.add(:base, 'Существуют товарные позиции!')
      return false
    end
  end
end
