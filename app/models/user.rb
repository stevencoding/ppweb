#encoding: utf-8
class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_secure_password
  attr_accessible :email, :username, :bio, :role, :bean, :freetime, :password, :password_confirmation, :token

  serialize :freetime

  before_create { generate_token(:token) }

  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}, :reserved_name => true

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :email_format => true
  validates :password, :length => { :minimum => 6 }, :on => :create

  has_many :events
  has_many :event_memberships, class_name: 'Membership', foreign_key: "event_member_id"
  has_many :event_guests, class_name: 'Membership', foreign_key: "event_guest_id"

  has_many :notifications, foreign_key: "receiver_id", dependent: :destroy

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

  def attended_events
    self.event_memberships.map(&:event)
  end
end
