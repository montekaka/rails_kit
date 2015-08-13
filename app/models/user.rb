class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # Instruction of confirmable
  # https://github.com/plataformatec/devise/wiki/How-To:-Add-:confirmable-to-Users
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, 
         :trackable, :validatable, :confirmable,
         :omniauthable, :omniauth_providers => [:facebook]
  include DeviseIosRails::OAuth

  has_many :pins

	def self.from_omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid	    
	    user.oauth_token = auth.credentials.token	    
	    user.email = auth.uid+"@facebook.com"
	  end
	end  

	def self.new_with_session(params, session)
		if session["devise.user_attributes"]
			new(session["devise.user_attributes"], without_protection: true) do |user|
				user.attributes = params
				user.valid?
			end
		else
			super
		end
	end

	def password_required?
		super && provider.blank?
	end

	def update_with_password(params, *options)
		if encrypted_password.blank?
			update_attributes(params, *options)
		else
			super
		end
	end
end
