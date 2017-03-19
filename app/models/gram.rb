class Gram < ApplicationRecord
  #before_action :authenticate_user!
  mount_uploader :picture, PictureUploader

  validates :message, presence: true
  belongs_to :user

end
