class Vote < ApplicationRecord
  belongs_to :user, -> { select(:id, :name, :username) }
  belongs_to :slang
end
