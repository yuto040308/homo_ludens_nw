class Event < ApplicationRecord
    # refileでattachment_fieldを使う場合、ここに指定しないと動かない _idは外す
    attachment :event_image

    has_many :event_joins

    belongs_to :play, optional: true
    belongs_to :user, optional: true
end
