class EmailController < ApplicationController
  def new
    identity = Identity.find(params[:identity_id])
  end

  #tell the user go confirm his email
  def show

  end

  def create
    identity = Identity.find(params[:identity_id])
    identity.build_email(:address => params[:email])
    identity.save!
    redirect_to identity_email_path(identity, identity.email)
  end


  def confirm
    identity = Identity.find(params[:identity_id])
    if identity.email.verification_token === params[:verification_token]
      @identity = identity
    else
      raise Mongoid::Errors::DocumentNotFound, "Email verification does not exist"
    end
  end

  def verify
    identity = Identity.find(params[:identity_id])
    if identity.email.verification_token === params[:verification_token]
      identity.email.is_verified = true
      identity.email.save!
      redirect_to identity_email_verified_path(identity, identity.email)
    else
      raise Mongoid::Errors::DocumentNotFound, "Email verification does not exist"
    end
  end

  def verified

  end
end