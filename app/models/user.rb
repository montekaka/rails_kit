class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
  include DeviseIosRails::OAuth

  has_many :pins

	def self.from_omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid	    
	    user.oauth_token = auth.credentials.token
	    user.save!
	  end
	end  

	def self.new_with_session(params, seesion)
		if seesion["devise.user_attributes"]
			new(session["devise.user_attributes"], without_protection: true) do |use|
				user.user_attributes = params
				user.valid?
			end
		else
			super
		end
	end
end
