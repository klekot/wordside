class CreateCounters < ActiveRecord::Migration
  def change
    create_table :counters do |t|
      t.integer :counter
      t.references :article, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
