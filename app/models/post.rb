# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :body, presence: true, length: { minimum: 10, maximum: 100_000 }
  belongs_to :user
  has_many :comments, dependent: :destroy

  has_noticed_notifications model_name: 'Notification'

  # has_many :notifications, through: :user, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  has_many :likes, counter_cache: true


  mount_uploader :avatar, AvatarUploader
  validates  :avatar ,file_size: {less_than: 2.megabytes}
  
  acts_as_votable
end
