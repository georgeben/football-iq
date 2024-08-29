class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :logo, null: false
      t.string :league, null: false

      t.timestamps
    end
  end
end
