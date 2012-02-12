class Email
  include Mongoid::Document
  field :email, :type => String
  field :is_verified, :type => Boolean
  field :verification_token, :type => String

  belongs_to :user

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of :email, :without => /proxymail\.facebook\.com/i
end
