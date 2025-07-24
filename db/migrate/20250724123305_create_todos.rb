class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.boolean :completed, default: false
      t.string :priority, default: "low"

      t.timestamps
    end
  end
end
