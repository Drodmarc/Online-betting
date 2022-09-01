class Offer < ApplicationRecord
  validates :image, :name, :genre, :status,  presence: true
  validates :amount, :coin, numericality: { greater_than: 0 }

  mount_uploader :image, ImageUploader

  enum status: [:active, :inactive]
  enum genre: [:one_time, :monthly, :weekly, :daily, :regular]
end
