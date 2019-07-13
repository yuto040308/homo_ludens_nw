class EventJoin < ApplicationRecord
    belongs_to :event, optional: true
end
