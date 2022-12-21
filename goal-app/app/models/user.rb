class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  after_initialize :ensure_session_token

  attr_reader :password

  def password=(new_pass)
    self.password_digest = BCrypt::Password.create(new_pass)
    @password = new_pass
  end

  def is_password?(new_pass)
    password_obj = BCrypt::Password.new(self.password_digest)
    password_obj.is_password?(new_pass)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end
end
