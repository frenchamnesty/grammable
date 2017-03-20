class Gram < ApplicationRecord
  #before_action :authenticate_user!
  mount_uploader :picture, PictureUploader

  validates :message, presence: true
  validates :picture, presence: true

  belongs_to :user
  has_many :comments

end
