require 'spec_helper'

describe PhoneNumber do
  describe 'class methods' do
    it { PhoneNumber.should respond_to :npa }
    it { PhoneNumber.should respond_to :nxx }
    it { PhoneNumber.should respond_to :nxx_list }
    it { PhoneNumber.should respond_to :line }
    it { PhoneNumber.should respond_to :line_list }
    it { PhoneNumber.should respond_to :toll_free_npa }

    it 'should have every correct npa' do
      npa.each do |n|
        PhoneNumber.npa.should include n.to_sym
      end
    end

    it 'should have a correct nxx' do
      PhoneNumber.nxx.should include :'244'
    end

    it 'should not have an incorrect nxx' do
      PhoneNumber.nxx.should_not include :'100'
    end

    it 'should have a correct npa-nxx combo for an npa' do
      PhoneNumber.nxx_list(244).should include :'244533'
    end

    it 'should have a correct line' do
      PhoneNumber.line.should include :'4115'
    end

    it 'should have a correct phone number for a npa-nxx combo' do
      PhoneNumber.line_list(773, 629).should include :'7736292443'
    end

    it 'should have all the correct toll free npas' do
      toll_free_npa.each do |tn|
        PhoneNumber.toll_free_npa.should include tn.to_sym
      end
    end

    it 'normalizes various input' do
      PhoneNumber.normalize_number('7736292443').should eq :'7736292443'
      PhoneNumber.normalize_number('+17736292443').should eq :'7736292443'
      PhoneNumber.normalize_number('123').should eq nil
      PhoneNumber.normalize_number('1-800-412-5511').should eq :'8004125511'
      PhoneNumber.normalize_number('adam: +1 (773) 629 2554').should eq :'7736292554'
    end
  end

  describe 'phone number validation' do
    it 'says valid numbers are valid' do
      PhoneNumber.new(7736292443).should be_valid
      PhoneNumber.new(17736292443).should be_valid
      PhoneNumber.new('+17736292443').should be_valid
      PhoneNumber.new('+1 (773)629-2443').should be_valid
      PhoneNumber.new('+1 (800) 232 4411').should be_valid
    end

    it 'says invalid number are invalid' do
      PhoneNumber.new('+1 (883) 232 4411').should_not be_valid
      PhoneNumber.new(1114445959).should_not be_valid
      PhoneNumber.new('7738585').should_not be_valid
    end
  end

  describe 'split up valid numbers' do
    subject { PhoneNumber.new(number) }

    context do
      let(:number) { 7736292443 }

      its(:number) { should eq :'7736292443' }
      its(:npa)    { should eq :'773' }
      its(:nxx)    { should eq :'629' }
      its(:line)   { should eq :'2443' }
    end

    context do
      let(:number) { 17736292443 }

      its(:number) { should eq :'7736292443' }
      its(:npa)    { should eq :'773' }
      its(:nxx)    { should eq :'629' }
      its(:line)   { should eq :'2443' }
    end

    context do
      let(:number) { '+17736292443' }

      its(:number) { should eq :'7736292443' }
      its(:npa)    { should eq :'773' }
      its(:nxx)    { should eq :'629' }
      its(:line)   { should eq :'2443' }
    end

    context do
      let(:number) { '+1 (773)629-2443' }

      its(:number) { should eq :'7736292443' }
      its(:npa)    { should eq :'773' }
      its(:nxx)    { should eq :'629' }
      its(:line)   { should eq :'2443' }
    end

    context do
      let(:number) { '+1 (800) 232 4411' }

      its(:number) { should eq :'8002324411' }
      its(:npa)    { should eq :'800' }
      its(:nxx)    { should eq :'232' }
      its(:line)   { should eq :'4411' }
    end
  end

  describe '#persisted?' do
    subject { PhoneNumber.new(7736292443) }

    its(:persisted?) { should be_false }
  end

  describe '#to_param' do
    subject { PhoneNumber.new(7736292443) }

    its(:to_param) { should eq :'7736292443' }
  end

  describe '#caller_id' do
    subject { PhoneNumber.new(number) }

    context 'real number' do
      let(:number) { 7736292663 }
      #boring caller id example...
      its(:caller_id) { should eq 'WIRELESS CALLER' }
    end

    context 'invalid number' do
      let(:number) { 800 }

      its(:caller_id) { should be_nil }
    end
  end

  describe '#telco_info' do
    subject { PhoneNumber.new(number) }

    context 'real number' do
      let(:number) { 7736292663 }

      its(:telco_info) { should be_an_instance_of Hash }
      its(:telco_info) { should eq telco_info_response }
    end

    context 'invalid number' do
      let(:number) { 800 }

      its(:telco_info) { should be_nil }
    end
  end
end
