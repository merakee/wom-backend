class User < ActiveRecord::Base
  belongs_to :user_type
  has_many :content, dependent: :destroy
  has_many :user_response, dependent: :destroy
  validates :user_type, presence: true
  validates :password_confirmation, presence: true
  validates_format_of :email,:with => Devise.email_regexp
  validates_confirmation_of :password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
  :registerable,
  :recoverable,
  :rememberable,
  :trackable,
  :validatable

  #attr_accessible :name, :email, :authentication_token

  before_save :ensure_authentication_token!
  
  def set_anonymous_user
    self.authentication_token = generate_authentication_token
    self.email = "#{self.authentication_token}@email.com"
  end
  def ensure_authentication_token!
    self.authentication_token ||= generate_authentication_token
  end

  def reset_authentication_token!
    # exclude anonymous users 
    self.update_attribute(:authentication_token, generate_authentication_token) if self.user_type_id != 1
  end

  def is_anonymous?
    self.user_type_id == 1 
  end
  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
