class City < ApplicationRecord
  validates :code, :name, presence: true

  belongs_to :province
  has_many :barangays
end
