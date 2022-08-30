class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :phone, phone: {allow_blank: true}
  has_many :addresses
  belongs_to :parent,  class_name: "User",counter_cache: :children_members, optional: true
  has_many :children, class_name: "User" , foreign_key: :parent_id
  has_many :bets
  has_many :winners

  def admin?
    role == 'admin'
  end

  def client?
    role == 'client'
  end

  mount_uploader :image, ImageUploader
end
