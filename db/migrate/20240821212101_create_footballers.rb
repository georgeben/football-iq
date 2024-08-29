class CreateFootballers < ActiveRecord::Migration[7.1]
  def change
    create_table :footballers do |t|
      t.jsonb :data, null: false, default: {}
      t.string  :digest, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
