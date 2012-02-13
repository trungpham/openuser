class Email
  include Mongoid::Document
  field :address, :type => String
  field :is_verified, :type => Boolean, :default => false
  field :verification_token, :type => String

  belongs_to :user

  embedded_in :identity

  validates_format_of :address, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of :address, :without => /proxymail\.facebook\.com/i

  after_validation :generate_verification_token

  def generate_verification_token
    unless is_verified
      self.verification_token = BSON::ObjectId.new #this should generate a unique id
    end
  end
end
