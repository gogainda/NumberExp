require 'spec_helper'

describe PhonenumbersController do
  render_views

  describe 'npa index' do
    subject { get :index_npa }

    it { should be_success }
    it 'has links to npa indexes' do
      PhoneNumber.npa.sample(10).each do |npa|
        subject.body.should have_link npa, index_npa_path(npa: npa)
      end
    end
  end

  describe 'nxx index' do
    subject { get :index_nxx, npa: random_npa }
    let(:random_npa) { PhoneNumber.npa.sample }

    it { should be_success }
    it 'has links to npa-nxx indexes' do
      PhoneNumber.nxx.sample(10).each do |nxx|
        subject.body.should have_link "#{random_npa}-#{nxx}", index_nxx_path(npa: random_npa, nxx: nxx)
      end
    end
  end

  describe 'line index' do
    subject { get :index_line, npa: random_npa, nxx: random_nxx }
    let(:random_npa) { PhoneNumber.npa.sample }
    let(:random_nxx) { PhoneNumber.nxx.sample }

    it { should be_success }
    its(:body) { should have_selector 'div.pagination'}
    its(:body) { should have_link '1', href: '#'}
    it 'has links to phone numbers' do
      PhoneNumber.line.first(1000).sample(10).each do |line|
        number = "#{random_npa}#{random_nxx}#{line}"
        subject.body.should have_link "#{random_npa}-#{random_nxx}-#{line}", phonenumber_path(id: number)
      end
    end
  end

  describe 'show number' do
    it 'succeeds for valid numbers' do
      valid_numbers = ['7736221234', '+1 (800) 123-1234']
      valid_numbers.each do |number|
        get :show, id: number
        number = number.gsub(/\D/,'')[-10..-1]
        readable_number = "#{number[0..2]}-#{number[3..5]}-#{number[6..9]}"
        response.should be_success
        response.body.should have_selector 'h1', text: readable_number
      end
    end

    it 'fails for invalid numbers' do
      invalid_numbers = ['773621234', '+1 (100) 123-1234', 'cats']
      invalid_numbers.each do |number|
        get :show, id: number
        flash[:error].should_not be_nil
        response.should redirect_to :root
      end
    end
  end

  describe 'search' do
    it 'succeeds for valid numbers' do
      valid_numbers = ['7736221234', '+1 (800) 123-1234']
      valid_numbers.each do |number|
        get :search, number: number
        number = number.gsub(/\D/,'')[-10..-1]
        readable_number = "#{number[0..2]}-#{number[3..5]}-#{number[6..9]}"
        response.should redirect_to phonenumber_path(id: number)
      end
    end

    it 'fails for invalid numbers' do
      invalid_numbers = ['773621234', '+1 (100) 123-1234', 'cats']
      invalid_numbers.each do |number|
        get :search, number: number
        flash[:error].should_not be_nil
        response.should redirect_to :root
      end
    end
  end

  describe 'caller_id' do
    it 'returns caller id' do
      get :caller_id, phonenumber_id: 7736292663, format: :json
      response.body.should eq 'WIRELESS CALLER'
    end
  end
end
