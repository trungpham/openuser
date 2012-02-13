class SessionsController < ApplicationController
  def create

    identity = Identity.get_identity_from_omniauth(auth_hash)

    if identity.user #if this identity has been linked before
      sign_in(identity.user)
      render :action => :success
    elsif !identity.email_verified? || !identity.has_email?
      redirect_to new_identity_email_path(identity)
    elsif identity.email_verified? && identity.user.nil? #email is verified but no user exists
      #create the user
      fake_password = SecureRandom.hex(10)
      user = User.new(:email => identity.email_address, :name => identity.info['name'], :password => fake_password, :password_confirmation => fake_password)

      user.save!

      identity.user = user

      identity.save!

      sign_in(user)
      render :action => :success

    end
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end