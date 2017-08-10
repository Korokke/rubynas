class User < ApplicationRecord
  attr_reader :password
  attr_accessor :password_confirmation

  # presence : cannot be blank
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, in: 1..20, allow_blank: true
  validates_format_of :name, without: /[^\w]/i
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates_length_of :password, in: 6..20, allow_blank: true
  validates_confirmation_of :password, message: 'should match confirmation'
  validates_presence_of :password

  before_destroy :before_destroy_check_admin

  def to_param
    return self.name
  end

  def password=(new_password)
    @password = new_password
    unless @password.blank?
      self.password_salt = SecureRandom.base64(32)
      self.password_digest = Digest::SHA256.hexdigest(self.password_salt + @password)
    end
  end

  def admin?
    return self.name == "admin"
  end

  def self.authenticate(name, password)
    user = find_by_name(name) or return nil
    hash = Digest::SHA256.hexdigest(user.password_salt + password)
    return hash == user.password_digest ? user : nil
  end

  def before_destroy_check_admin
    raise "cannot destroy admin" if admin?
  end
end
