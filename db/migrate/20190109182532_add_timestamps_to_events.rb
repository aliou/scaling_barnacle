class AddTimestampsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :created_at, :datetime, default: 'now()'
    add_column :events, :updated_at, :datetime, default: 'now()'
  end
end
