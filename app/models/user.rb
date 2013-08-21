class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :signup_token
  attr_accessor :password
  before_save :encrypt_password
  before_create {generate_token(:auth_token)}
  before_create {generate_token(:signup_token)}
  validates_presence_of     :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_length_of       :password, :within => 8...20, :allow_blank => true
  validates :email, presence: true, uniqueness: true
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "not valid"}

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64         
    end while User.exists?(column => self[column])
  end
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt) 
      user
    else
      nil
    end
  end

  def self.is_not_active(active)
    if active.nil?
      true
    elsif active == false
      true
    else
      false
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end