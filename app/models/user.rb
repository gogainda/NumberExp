class User < ActiveRecord::Base
  devise :registerable, :rememberable, :trackable, :database_authenticatable,
         :omniauthable, :recoverable, :validatable, omniauth_providers: [:facebook]

  store :info, accessors: [:first_name, :last_name, :name, :gender, :timezone, :username, :image, :nickname, :urls]

  attr_accessible :email, :password, :remember_me, :facebook_uid, :facebook_token

  validates_uniqueness_of :facebook_uid

  def self.from_facebook_omniauth(auth)
    user = where(facebook_uid: auth.uid).first_or_initialize
    user.update_with_facebook_info(auth)
  end

  def update_with_facebook_info(auth)
    base_info = auth.info
    raw_info = auth.extra.raw_info

    self.tap do |user|
      user.facebook_oauth_token = auth.credentials.token
      user.facebook_uid = auth.uid || raw_info.id
      user.email        = base_info.email || raw_info.email
      user.first_name   = base_info.first_name || raw_info.first_name
      user.last_name    = base_info.last_name || raw_info.last_name
      user.name         = base_info.name || raw_info.name
      user.gender       = raw_info.gender
      user.timezone     = raw_info.timezone
      user.username     = raw_info.username
      user.image        = base_info.image
      user.nickname     = base_info.nickname
      user.urls         = base_info.urls
      user.password     = SecureRandom.urlsafe_base64 unless user.encrypted_password?
    end
  end

  def premium_access?
    true
  end
end
