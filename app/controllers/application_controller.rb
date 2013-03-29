class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_uri

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, :alert => exception.message }
      format.json { render json: exception.message }
    end
  end

  def check_uri
    if Rails.env == 'production'
      if !/^www/.match(request.host) || !request.host.include?('numbernote')
        redirect_to(request.protocol + "www.numbernote.com" + request.fullpath, :status => 301)
      end
    end
  end
end
