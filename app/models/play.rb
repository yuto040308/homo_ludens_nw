class Play < ApplicationRecord

    # refileでattachment_fieldを使う場合、ここに指定しないと動かない _idは外す
    attachment :play_image

    belongs_to :category, optional: true

end
