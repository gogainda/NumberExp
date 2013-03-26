class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    user = User.from_facebook_omniauth(request.env['omniauth.auth'])
    if user.save
      sign_in :user, user
      flash[:success] = 'Signed in successfully!'
    else
      flash[:error] = 'Unable to sign in'
    end
    redirect_to :root
  end

end
