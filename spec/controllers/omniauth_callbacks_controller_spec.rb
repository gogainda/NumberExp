require 'spec_helper'

describe OmniauthCallbacksController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "#facebook" do
    def do_request
      get :facebook
    end

    context "with valid params" do
      let(:auth) { facebook_successful_auth_response }

      before(:each) do
        OmniAuth.config.mock_auth[:facebook] = auth
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      end

      it 'creates a new user' do
        expect {
          do_request
        }.to change {
          User.count
        }.by 1
      end

      it 'does not create an old user' do
        User.from_facebook_omniauth(auth).dup.save
        expect {
          do_request
        }.to_not change {
          User.count
        }
      end
    end
  end

end


