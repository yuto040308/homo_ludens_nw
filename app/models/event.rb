class Event < ApplicationRecord
    # refileでattachment_fieldを使う場合、ここに指定しないと動かない _idは外す
    attachment :event_image
end
