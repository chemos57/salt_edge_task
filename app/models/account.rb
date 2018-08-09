class Account < ApplicationRecord
  belongs_to :login
  has_many :transactions
end
