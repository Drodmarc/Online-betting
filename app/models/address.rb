class Address < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :genre
  validates_presence_of :is_default, { allow_blank: true }
  validates :phone_number, phone: true
  before_create :first_address_auto_default
  before_destroy :destroy_validation
  before_commit :update_default
  validate :limit_to_five_address, on: :create

  enum genre: [:Home, :Office]

  belongs_to :user
  belongs_to :region
  belongs_to :province
  belongs_to :city
  belongs_to :barangay

  def first_address_auto_default
    unless self.user.addresses.present?
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
      self.user.addresses.where("id != ?", self.id).update_all(is_default: false)
    end
  end

  def limit_to_five_address
    return unless self.user
    if self.user.addresses.count >= 4
      errors.add(:base, "Mali!!")
    end
  end
end
