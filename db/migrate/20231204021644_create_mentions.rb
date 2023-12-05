class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :mentioning, null: false, foreign_key: { to_table: :reports }
      t.references :mentioned, null: false, foreign_key: { to_table: :reports }
      t.timestamps

      t.index [:mentioning_id, :mentioned_id], unique: true
    end
  end
end
