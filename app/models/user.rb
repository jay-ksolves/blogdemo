# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # enum role: %i[admin editor normal_user]
  validates_length_of :name,
                      minimum: 5, maximum: 50,
                      presence: true,
                      uniqueness: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, format: { with: /\A[a-zA-Z0-9_\s]+\z/ }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy

  acts_as_voter

  has_many :likes
  has_many :liked_posts, through: :likes, source: :post

  has_one_attached :profile_image

  mount_uploader :userimage, AvatarUploader
  validates :userimage, file_size: { less_than: 2.megabytes }
end
