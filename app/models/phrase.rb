class Phrase < ApplicationRecord
  include SharedMethods
  extend FriendlyId
  include PublicActivity::Model

  tracked
  acts_as_votable

  LIKE = 4
  DISLIKE = -2

  friendly_id :phrase, use: :slugged
  has_many :examples, dependent: :destroy
  accepts_nested_attributes_for :examples, allow_destroy: true

  belongs_to :user
  validates :phrase, :translation, presence: true
  validates :phrase, :translation, uniqueness: true
  validates :phrase, :translation, format: { with: /\A[a-zA-Z',,,",.]+\z/,
                                             message: "Only letters and symbols ' , allowed" }
  validates :category, inclusion: { in: %w[Actions Time Productivity Apologies Common],
                                    message: '%{value} is not a valid categoty' }
  enum category: { Actions: 0, Time: 1, Productivity: 2, Apologies: 3, Common: 4 }
  def author?(user)
    self.user == user
  end
end
