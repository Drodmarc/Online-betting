class NewsTicker < ApplicationRecord
  validates :content, :status, presence: true
  belongs_to :admin, class_name: "User"

  enum status: [:active, :inactive]
  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end