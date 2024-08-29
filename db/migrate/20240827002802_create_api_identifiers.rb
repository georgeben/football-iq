class CreateApiIdentifiers < ActiveRecord::Migration[7.1]
  def change
    create_table :api_identifiers do |t|
      t.string :provider_name, null: false
      t.string :provider_id, null: false
      t.references :identifiable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :api_identifiers, [:provider_name, :provider_id, :identifiable_type], unique: true, name: 'idx_unique_api_identifiers'
  end
end
