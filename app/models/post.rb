# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :body, presence: true, length: { minimum: 10, maximum: 100_000 }
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many_attached :images
  has_noticed_notifications model_name: 'Notification'

  # has_many :notifications, through: :user, dependent: :destroy
  has_many :notifications,  dependent: :destroy

  acts_as_votable
end
