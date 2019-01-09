class CreateEvents < ActiveRecord::Migration
  def change
    create_range_partition :events, partition_key: -> { '(timestamp::DATE)' } do |t|
      t.string :event_type, null: false
      t.integer :value, null: false
      t.datetime :timestamp, null: false
    end
  end
end
