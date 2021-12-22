class User < ApplicationRecord
  has_secure_password

  # validates email
  validates :username, presence: true, uniqueness: true, length: { minimum: 1, maximum: 15 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  has_many :slangs
  has_many :votes
end
