require 'spec_helper.rb'

describe UsersController do
  render_views

  describe 'new' do
    subject { get :new }

    it { should be_success }
    its(:body) { should have_selector 'button[type=submit]', text: 'Search' }
    its(:body) { should have_selector "form[action='/users'][method=post]" }
    its(:body) { should have_selector 'input[type=email][name=email]' }
    its(:body) { should have_selector 'input[type=password][name=password]' }
  end
end
