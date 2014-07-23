class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :provider, :uid, :token, :token_secret

  field :provider,      type: String
  field :uid,           type: String
  field :token,         type: String
  field :token_secret,  type: String
  
  ## Relationships
  belongs_to :user

  def self.find_by_provider_and_uid(provider, uid)
    where(provider: provider, uid: uid).first
  end
end
