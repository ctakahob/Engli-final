class User < ApplicationRecord
  has_many :phrases, dependent: :destroy
  include PublicActivity::Model

  tracked

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, uniqueness: true
  validates :username, length: { minimum: 2 }

  def has_new_notifications?
    PublicActivity::Activity.where(recipient_id: id, readed: false).any?
  end

  def public_activities
    PublicActivity::Activity.where(recipient_id: id)
  end
end
