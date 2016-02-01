class LoginController < ApplicationController
  layout false
  def logout
    omniauth_logout
    redirect_to "/"
  end
  def public
    omniauth_logout if github_authenticated? :private
    github_authenticate! :default
  end
  def private
    omniauth_logout if github_authenticated? :default
    github_authenticate! :private
  end
  def github
    user = User.find_or_create_from_omniauth auth_hash
    session[:user_id] = user.id
    redirect_to session['return_to'] || "/"
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end
