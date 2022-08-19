class Category < ApplicationRecord
  validates :name, presence: true
  has_many :items

  default_scope { where(deleted_at: nil) }

  def destroy
    if self.items.blank?
      update(deleted_at: Time.current)
    else
      errors.add(:base, "Can't delete this category")
      return false
    end
  end
end
