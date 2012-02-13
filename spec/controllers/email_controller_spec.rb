require 'spec_helper'

describe EmailController do

  it 'should save the email address' do
    identity = FactoryGirl.create(:identity, :email => nil, :user => nil)
    post :create, :email => 'test@example.com', :identity_id => identity.id
    identity.reload
    identity.email_address.should == 'test@example.com'
    response.should redirect_to(identity_email_path(identity, identity.email))
  end

  it 'should confirm the email address and ask the user to verify it' do
    identity = FactoryGirl.create(:unverified_identity)
    identity.email_verified?.should be_false
    get :confirm, :identity_id => identity.id, :id => identity.email.id, :verification_token => identity.email.verification_token
    identity.reload
    identity.email_verified?.should be_false
  end

  it 'should verify the email address' do
    identity = FactoryGirl.create(:unverified_identity)
    identity.email_verified?.should be_false
    post :verify, :identity_id => identity.id, :id => identity.email.id, :verification_token => identity.email.verification_token
    identity.email.reload
    identity.email_verified?.should be_true
    response.should redirect_to(identity_email_verified_path(identity, identity.email))
  end
end