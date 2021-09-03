class Example < ApplicationRecord
  include SharedMethods
  include PublicActivity::Model

  tracked
  acts_as_votable

  UPVOTE = 2
  DOWNVOTE = -1

  belongs_to :user
  belongs_to :phrase
  validates :example, presence: true
  validates_uniqueness_of :example, scope: :phrase_id, message: 'has already been used!'
end
