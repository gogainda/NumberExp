class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    user = User.from_facebook_omniauth(request.env['omniauth.auth'])
    if user.save
      redirect_to :root
    else
      redirect_to :root
    end
  end

end
