class LoggedInConstraint
  def matches?(request)
    request.session[:user_github].present?
    #request.env['warden'].authenticated?(:private) ||
    #  request.env['warden'].authenticated?(:default)
  end
end
