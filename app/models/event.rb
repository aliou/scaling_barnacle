class Event < ApplicationRecord
  range_partition

  belongs_to :user, optional: true
end
