class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds, id: :uuid do |t|
      t.references :footballer, null: false, foreign_key: true
      t.integer :total_guesses, default: 0
      t.string :result

      t.timestamps
    end
  end
end
