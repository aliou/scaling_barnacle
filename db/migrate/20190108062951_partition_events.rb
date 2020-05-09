class PartitionEvents < ActiveRecord::Migration[5.0]
  def up
    # Get the bounds of the events.
    min_month = Event.minimum(:timestamp).beginning_of_month.to_date
    max_month = Event.maximum(:timestamp).beginning_of_month.to_date

    # Create the partition bounds based on the existing data. In this example,
    # we generate an array with the ranges.
    months = min_month.upto(max_month).uniq(&:beginning_of_month)

    # Rename the existing table.
    rename_table :events, :old_events

    # Create the partitioned table.
    options = { partition_key: -> { '(timestamp::DATE)' } }

    create_range_partition :events, options do |t|
      t.bigserial :id, null: false
      t.string :event_type, null: false
      t.integer :value, null: false
      t.datetime :timestamp, null: false
      t.timestamps
    end

    add_index :events, :event_type

    # Create the partitions based on the bounds generated before:
    months.each do |month|
      # Creates a name like "events_y2018m12"
      partition_name = "events_y#{month.year}m#{month.month}"

      create_range_partition_of :events,
        name: partition_name, range_start: month, range_end: month.next_month
    end

    # Finally, add the rows from the old table to the new partitioned table.
    # This might take some time depending on the size of your old table.
    execute(<<~SQL)
      INSERT INTO events
      SELECT * FROM old_events
    SQL

    drop_table :old_events, proc {}
  end
end
