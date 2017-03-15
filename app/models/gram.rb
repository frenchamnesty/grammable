class Gram < ApplicationRecord
  #before_action :authenticate_user!

  validates :message, presence: true

end
