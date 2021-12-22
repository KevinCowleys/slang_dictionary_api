class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :slang, null: false, foreign_key: true
      t.boolean :upvote, null: false

      t.timestamps
    end
  end
end
