#encoding: utf-8
class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :name, :password, :password_confirmation, :token
  before_create { generate_token(:token) }

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}, :reserved_name => true

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :email_format => true
  validates :password, :length => { :minimum => 6 }, :on => :create


  def has_avatar?
    self.read_attribute(:avatar).present?
  end

  def gravatar_url
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=512&d=retro"
  end

  def final_avatar_url
    self.has_avatar? ? self.avatar_url : self.gravatar_url
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
