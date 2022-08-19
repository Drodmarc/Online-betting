class Region < ApplicationRecord
  validates :code, :name, :region_name, presence: true

  has_many :provinces
end
