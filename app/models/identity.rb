class Identity
  include Mongoid::Document
  field :provider, :type => String
  field :uid, :type => String
  embeds_one :email
  field :info, :type => Hash
  belongs_to :user

  #add uniqueness constraint
  index(
    [
      [ :provider, Mongo::ASCENDING ],
      [ :uid, Mongo::ASCENDING ]
    ],
    unique: true
  )

  class MissingConfig < ArgumentError; end
  def self.get_identity_from_omniauth(auth_hash)
    identity = self.where(:provider => auth_hash['provider']).where(:uid => auth_hash['uid']).first

    unless identity
      identity = self.new(:provider => auth_hash['provider'],
                          :uid => auth_hash['uid'],
                          :info => auth_hash['info']
                          )

      unless auth_hash['info']['email'].blank?
        identity.build_email(:email => auth_hash['info']['email'])

        if config = IdentityConfig.get(auth_hash['provider'])

          if config[:email_verified]
            identity.email.is_verified = true
          else
            identity.email.is_verified = false
            identity.email.verification_token = BSON::ObjectId.new #this should generate a unique id
          end

        else
          raise MissingConfig, "Missing identity configuration data for #{auth_hash['provider']}"
        end
      end

      identity.safely.save!
    end
    identity
  end
end
