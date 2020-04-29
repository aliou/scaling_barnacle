class CreateEvents < ActiveRecord::Migration[5.0]
  def up
    create_table :events do |t|
      t.string :event_type, null: false, index: true
      t.integer :value, null: false
      t.datetime :timestamp, null: false
      t.timestamps
    end

    say_with_time('Creating events') do
      2_000.times.each_with_index do |index|
        Event.create!(event_type: 'test', value: index, timestamp: DateTime.current + index.days)
        printf '.'
      end
    end
  end

  def down
    drop_table :events
  end
end

