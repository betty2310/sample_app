class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validate.user.email.format

  validates :name, presence: true,
            length: {maximum: Settings.validate.user.name.length.max}
  validates :email, presence: true,
            length: {maximum: Settings.validate.user.email.length.max},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true

  before_save :downcase_email

  has_secure_password

  # Returns the hash digest of the given string.
  def digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost
  end

  private

  def downcase_email
    email.downcase!
  end
end
