class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = Settings.validate.user.email.format

  validates :name, presence: true,
            length: {maximum: Settings.validate.user.name.length.max}
  validates :email, presence: true,
            length: {maximum: Settings.validate.user.email.length.max},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  validates :password, presence: true,
            length: {minimum: Settings.validate.user.password.length.min},
            allow_nil: true

  before_save :downcase_email

  has_secure_password

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
