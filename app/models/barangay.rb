class Barangay < ApplicationRecord
  validates :code, :name, presence: true

  belongs_to :city
end
