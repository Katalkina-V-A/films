class Film < ActiveRecord::Base
  has_attached_file :cover, styles: {medium: "250x250>", thumb: "100x100>"}

  belongs_to :country
  belongs_to :genre
  belongs_to :director, class_name: 'Person'
  has_and_belongs_to_many :people, -> { ordering }
  has_and_belongs_to_many :books, -> { ordering }

  validates :name, presence: true
  validates :country, presence: true
  validates :director, presence: true
  validates :genre, presence: true
  validates :length, numericality: {only_integer: true, greater_than: 0}, allow_blank: true
  validates :year, numericality: {only_integer: true, greater_than: 1885}, allow_blank: true
  validate :check_people
  # validate :check_books
  validates_attachment :cover, content_type: {content_type: /\Aimage\/.*\z/}


  scope :ordering, -> { order(:year, :name) }
  scope :base, -> {includes(:genre)}
  scope :full, -> { includes(:country, :genre, :director, :people, :books) }

  attr_reader :person_tokens
  attr_reader :book_tokens

  def self.edit_by?(u)
    u.try(:admin?)
  end


  def person_tokens=(val)
    self.person_ids = val.split(',')
  end

  def book_tokens=(val)
    self.book_ids = val.split(',')
  end


  private
  def check_people
    errors.add(:people, :blank) if people.blank?
    true
  end

  # def check_books
  #   errors.add(:books, :blank) if books.blank?
  #   true
  # end

end
