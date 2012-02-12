class SessionsController < ApplicationController
  def create

  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end