class CreateChores < ActiveRecord::Migration[5.0]
  def up
    execute('CREATE EXTENSION IF NOT EXISTS btree_gist')

    create_table :chores do |t|
      t.references :user, foreign_key: true, index: true
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false

      t.timestamps
    end

    constraint_query = <<~SQL.strip
      ALTER TABLE chores ADD CONSTRAINT no_overlapping_chores_for_user
      EXCLUDE USING GIST (user_id with =, tsrange(starts_at, ends_at, '[]') with &&)
    SQL
    execute(constraint_query)
  end

  def down
    drop_table :chores
  end
end
