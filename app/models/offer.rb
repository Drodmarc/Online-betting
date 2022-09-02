class Offer < ApplicationRecord
  validates :image, :name, :genre, :status,  presence: true
  validates :amount, :coin, numericality: { greater_than: 0 }
  has_many :orders
  mount_uploader :image, ImageUploader

  enum status: [:active, :inactive]
  enum genre: [:one_time, :monthly, :weekly, :daily, :regular]
end
