class ApiIdentifier < ApplicationRecord
  belongs_to :identifiable, polymorphic: true

  validates :provider_name, presence: true

  validates :provider_id, presence: true, uniqueness: { scope: :provider_name }
end
