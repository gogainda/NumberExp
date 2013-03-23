class PagesController < ApplicationController

  def home
    @npas = PhoneNumber.npa
  end

  def privacypolicy
  end

  def termsofuser
  end

end
