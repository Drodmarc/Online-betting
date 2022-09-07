class Address < ApplicationRecord
  LIMIT = 5
  validates :name, :street_address, :genre, presence: true
  validates_presence_of :is_default, { allow_blank: true }
  validates :phone_number, phone: true
  before_create :first_address_auto_default
  before_destroy :destroy_validation
  before_commit :update_default
  validate :limit_to_five_address, on: :create

  enum genre: [:home, :office]

  belongs_to :user
  belongs_to :region
  belongs_to :province
  belongs_to :city
  belongs_to :barangay

  def first_address_auto_default
    unless user.addresses.present?
      self.is_default = true
    end
  end

  def destroy_validation
    if is_default
      throw(:abort)
    end
  end

  def update_default
    if is_default
      user.addresses.where.not(id: id).update_all(is_default: false)
    end
  end

  def limit_to_five_address
    if user.addresses.count >= LIMIT
      errors.add(:base, "You reach the limit")
    end
  end
end
