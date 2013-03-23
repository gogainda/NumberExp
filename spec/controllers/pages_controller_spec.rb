require 'spec_helper.rb'

describe PagesController do
  render_views

  describe 'home page' do
    subject { get :home }

    it { should be_success }
    its(:body) { should have_selector 'button[type=submit]', text: 'Search' }
    its(:body) { should have_selector "form[action='/n/search'][method=get]" }
    its(:body) { should have_selector 'input[type=text][name=number]' }
  end

  describe 'privacy policy page' do
    subject { get :privacypolicy }

    it { should be_success }
    its(:body) { should have_selector 'h1', text: 'Privacy Policy' }
  end

  describe 'terms of use page' do
    subject { get :termsofuse }

    it { should be_success }
    its(:body) { should have_selector 'h1', text: 'Terms of Use' }
  end
end
