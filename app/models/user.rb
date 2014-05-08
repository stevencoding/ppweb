#encoding: utf-8
class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :name, :password, :password_confirmation, :token
  before_create { generate_token(:token) }

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false},
            :format => { with: /\A[a-z0-9][a-z0-9-]*\z/i, message: '只能使用字母、数字或 - 号，并且不能以 - 号开头'}

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :email_format => true
  validates :password, :length => { :minimum => 6 }, :on => :create

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
