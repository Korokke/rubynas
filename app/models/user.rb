class User < ApplicationRecord
  attr_reader :password
  attr_accessor :password_confirmation
  attr_accessor :password_required

  # presence : cannot be blank
  validates_presence_of :name, :unless => :new_record?
  validates_uniqueness_of :name, :unless => :new_record? && :name_is_blank?
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/
  validates_confirmation_of :password
  validates_length_of :password, :in => 6..20, :allow_blank => true
  validates_presence_of :password, :if => :password_required

  # before_destroy :before_destroy_check_admin

  def password=(new_password)
    @password = new_password
    self.password_salt = SecureRandom.base64(32)
    self.encrypted_password = Digest::SHA256.hexdigest(self.password_salt + @password)
  end

  def self.authenticate(name, password)
    user = find_by_name(name) or return nil
    hash = Digest::SHA256.hexdigest(user.password_salt + password)
    return hash == user.password_digest ? user : nil
  end
  
  # def before_destroy_check_admin
  #   raise "cannot destroy admin" if is_admin
  # end
end