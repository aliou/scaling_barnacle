class CreateTestPartitions < ActiveRecord::Migration[5.0]
  def change
    # Create the events table as a partitioned table using range as partitioning method
    # and `event_date` as partition key.
    create_range_partition :range_partition, partition_key: 'event_date' do |t|
      t.string :event_type, null: false
      t.integer :value, null: false
      t.date :event_date, null: false
    end

    # Create partitions with the bounds of the partition.
    create_range_partition_of :range_partition,
      name: 'range_y2018m12', range_start: '2018-12-01', range_end: '2019-01-01'

    # Create the events table as a partitioned table using list as partitioning method
    # and `event_date` as partition key.
    create_list_partition :list_partition, partition_key: 'event_date' do |t|
      t.string :event_type, null: false
      t.integer :value, null: false
      t.date :event_date, null: false
    end

    # Create partitions with the bounds of the partition.
    create_list_partition_of :list_partition,
      name: 'list_y2018m12', values: (Date.parse('2018-12-01')..Date.parse('2018-12-31')).to_a
  end
end
