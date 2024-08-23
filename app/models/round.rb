class Round < ApplicationRecord
  MAX_ATTEMPTS = 20

  belongs_to :footballer

  has_many :guesses, dependent: :destroy

  def attempts_left
    MAX_ATTEMPTS - total_guesses
  end
end
