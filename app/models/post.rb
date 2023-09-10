# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :body, presence: true, length: { minimum: 10, maximum: 100000 }
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many_attached :images
end
