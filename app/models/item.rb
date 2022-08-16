class Item < ApplicationRecord
  validates_presence_of  :image
  validates_presence_of :name
  validates_presence_of  :quantity
  validates_presence_of  :minimum_bets
  validates_presence_of  :online_at
  validates_presence_of :offline_at
  validates_presence_of  :start_at
  validates_presence_of  :status

  mount_uploader :image, ImageUploader

  enum status: [:Active, :Inactive]

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end
