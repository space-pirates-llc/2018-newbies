class RemitRequestResult < ApplicationRecord
  belongs_to :user
  belongs_to :target, class_name: 'User'
end
