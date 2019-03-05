class Pitch <ActiveRecord::Base
    belongs_to :users
    has_one :genre
    has_many :votes
end