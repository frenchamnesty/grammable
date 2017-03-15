class Gram < ApplicationRecord
  #before_action :authenticate_user!

  validates :message, presence: true
  belongs_to :user
  
end
