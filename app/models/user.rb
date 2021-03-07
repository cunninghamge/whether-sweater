class User < ApplicationRecord
  validates :email,
            uniqueness: true,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  has_secure_password
  has_secure_token :api_key
end
