class Round < ApplicationRecord
  MAX_ATTEMPTS = 10

  belongs_to :footballer

  has_many :guesses, dependent: :destroy

  def attempts_left
    MAX_ATTEMPTS - total_guesses
  end
end
