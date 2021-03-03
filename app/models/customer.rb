class Customer < ApplicationRecord
    belongs_to :client
    has_many :booking_requests, dependent: :nullify
end
