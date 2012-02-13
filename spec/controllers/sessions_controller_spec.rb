require "spec_helper"

describe SessionsController do

  context 'OAuth callback' do
    context 'User does not exist in the system' do
      context 'Facebook provide a good email address' do
        before :each do
          IdentityConfig.stub(:get).and_return({
                                                  :email_verified => true
                                               })

        end
        it 'should create a user account and a identity and let the user logs in' do
          controller.stub(:auth_hash).and_return({'provider' => 'facebook', 'uid' => '123',
                                                 'info' => {
                                                     'email' => 'user@example.com',
                                                     'name' => 'Test User'
                                                    }

                                                 })

          expect do
            expect do
              get :create
              response.should render_template('sessions/success')
              controller.current_user.should_not be_nil
              Identity.last.user.should == User.last
            end.to change {User.count}.by(1)
          end.to change {Identity.count}.by(1)
        end

      end

      context 'Facebook email address is missing' do
        it 'should ask the user for their email address' do

          controller.stub(:auth_hash).and_return({'provider' => 'facebook', 'uid' => '123',
                                                  'info' => {
                                                      'name' => 'Test User'
                                                  }

                                                 })

          expect do
            expect do
              get :create
              response.should redirect_to(new_identity_email_path(Identity.last))
              controller.current_user.should  be_nil
              Identity.last.user.should == User.last
            end.to change {User.count}.by(0)
          end.to change {Identity.count}.by(1)

        end
      end
    end
  end

  context 'User already exists in the system' do
    context 'User has not linked with Facebook yet' do

    end

    context 'User already linked with Facebook' do
      it 'should let the user login without creating a new user account or identity' do
        identity = FactoryGirl.create(:identity)

        controller.stub(:auth_hash).and_return({'provider' => identity.provider, 'uid' => identity.uid,
                                                   'info' => {
                                                       'email' => 'user@example.com',
                                                       'name' => 'Test User'
                                                      }

                                                   })

        expect do
          expect do
            get :create
            response.should render_template('sessions/success')
            controller.current_user.should_not be_nil
          end.to change {User.count}.by(0)
        end.to change {Identity.count}.by(0)
      end
    end
  end
end