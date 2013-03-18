class PagesController < ApplicationController

  def home
    @homepage = true
    @npas = PhoneNumber.npa
  end

  def privacypolicy
  end

  def termsofuser
  end

end
