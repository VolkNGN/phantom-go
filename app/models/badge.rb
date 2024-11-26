class Badge < ApplicationRecord
  has_many :achievements
  has_many :players, through: :achievements
end
