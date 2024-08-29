class Team < ApplicationRecord
  has_many :api_identifiers, as: :identifiable

  validates :name, presence: true
  validates :league, presence: true

end
