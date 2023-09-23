# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # enum role: %i[admin editor normal_user]

  # username
  validates_length_of :name,
                      minimum: 5, maximum: 50,
                      presence: true,
                      uniqueness: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, format: { with: /\A[a-zA-Z0-9_\s]+\z/ }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # comments
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # notification
  has_many :notifications, as: :recipient, dependent: :destroy

  acts_as_voter
  # likes
  has_many :likes
  has_many :liked_posts, through: :likes, source: :post

  # has_one_attached :profile_image
  # user image
  mount_uploader :userimage, AvatarUploader
  validates :userimage, file_size: { less_than: 2.megabytes }

  # stripe
  after_create do
    stripe_customer = Stripe::Customer.create(email: email)
    # stripe_customer_id = stripe_customer.id
    update(stripe_customer_id: stripe_customer.id)
  end

  def active?
    return true if plan == 'lifetime'
    return false unless subscription_ends_at.present?

    subscription_ends_at > Time.zone.now
  end
end
