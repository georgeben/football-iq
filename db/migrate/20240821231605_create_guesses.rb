class CreateGuesses < ActiveRecord::Migration[7.1]
  def change
    create_table :guesses do |t|
      t.references :round, type: :uuid, null: false, foreign_key: true
      t.text :message, null: false
      t.string :response, null: false

      t.timestamps
    end
  end
end
