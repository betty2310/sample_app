class User < ApplicationRecord
  VALID_EMAIL_REGEX = Regexp.new Settings.validate.user.email.format

  validates :name, presence: true,
            length: {maximum: Settings.validate.user.name.length.max}
  validates :email, presence: true,
            length: {maximum: Settings.validate.user.email.length.max},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true

  before_save :downcase_email

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
