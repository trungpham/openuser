require 'spec_helper'

describe Identity do

  let(:auth_data) do
    {
        'provider' => 'facebook',
        'uid' => '123',
        'info' => {
            'name' => 'Trung Pham',
            'email' => 'user@example.com'
        }
    }

  end
  it 'should create a new identity if it has not exist' do

    expect do
      identity = Identity.get_identity_from_omniauth(auth_data)
      identity.should be_an_instance_of(Identity)
    end.to change {Identity.count}.by(1)

  end

  it 'should say email is verified' do
    IdentityConfig.stub(:get).and_return( {
      :email_verified => true
    })
    identity = Identity.get_identity_from_omniauth(auth_data)

    identity.has_email?.should be_true
    identity.email_address.should == 'user@example.com'
    identity.email_verified?.should be_true

  end
  it 'should fetch the identity instead of creating a new one' do

    identity1 = Identity.get_identity_from_omniauth(auth_data)

    expect do
      identity2 = Identity.get_identity_from_omniauth(auth_data)

      identity1.should == identity2
    end.not_to change {Identity.count}


  end

  it 'should attach the email address and set it verified' do
    IdentityConfig.set('facebook', {
      :email_verified => true
    })
    identity = Identity.get_identity_from_omniauth(auth_data)
    identity.email.is_verified.should be_true
    identity.email.address.should == 'user@example.com'
  end

  it 'should attach the email address and generate a verification_token' do
    IdentityConfig.set('facebook', {
      :email_verified => false
    })
    identity = Identity.get_identity_from_omniauth(auth_data)
    identity.email.is_verified.should be_false
    identity.email.verification_token.should_not be_blank
  end

  it 'should raise an exception if identity config is missing' do

    IdentityConfig.should_receive(:get).with('facebook').and_return(nil)
    expect do
      Identity.get_identity_from_omniauth(auth_data)
    end.to raise_error(Identity::MissingConfig)



  end
end