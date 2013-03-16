require 'spec_helper'

describe User do
  describe 'validations' do
    it { should validate_presence_of :facebook_uid }
    it { should validate_uniqueness_of :facebook_uid }
  end

  describe '#info key-value store' do
    describe 'support for accessing attributes via #info hash' do
      its(:info) { should be_an_instance_of Hash }
    end

    describe 'support for custom accessors in store' do
      it { should respond_to :first_name }
      it { should respond_to :last_name }
      it { should respond_to :name }
      it { should respond_to :gender }
      it { should respond_to :timezone }
      it { should respond_to :username }
      it { should respond_to :image }
      it { should respond_to :nickname }
      it { should respond_to :urls }
    end
  end

  describe '.from_facebook_omniauth' do
    let(:auth)     { facebook_successful_auth_response }
    let(:raw_info) { auth.extra.raw_info }

    context 'new user' do
      subject { User.from_facebook_omniauth auth }

      it 'creates a new user' do
        expect { subject.save }.to change { User.count }.by 1
      end

      it { should be_an_instance_of User }

      its(:facebook_oauth_token) { should eq auth.credentials.token }
      its(:email)      { should eq auth.info.email }
      its(:first_name) { should eq auth.info.first_name }
      its(:last_name)  { should eq auth.info.last_name }
      its(:name)       { should eq auth.info.name }
      its(:gender)     { should eq raw_info.gender }
      its(:timezone)   { should eq raw_info.timezone }
      its(:username)   { should eq raw_info.username }
      its(:image)      { should eq auth.info.image }
      its(:nickname)   { should eq auth.info.nickname }
      its(:urls)       { should eq auth.info.urls }
    end

    context 'existing user' do
      subject { User.from_facebook_omniauth auth }

      it 'does not create a new user' do
        lambda do
          FactoryGirl.build! :facebook_user
          expect { subject.save }.to_not change { User.count }
        end
      end
    end
  end
end
