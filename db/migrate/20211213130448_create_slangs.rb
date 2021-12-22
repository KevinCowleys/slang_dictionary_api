class CreateSlangs < ActiveRecord::Migration[6.1]
  def change
    create_table :slangs do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :word, null: false
      t.string :definition, null: false
      t.boolean :is_approved, default: false

      t.timestamps
    end
  end
end
