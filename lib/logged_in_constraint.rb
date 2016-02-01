class LoggedInConstraint
  def matches?(request)
    request.env['omniauth.auth'].present? && request.env['omniauth.auth'].try('provider') == 'github'
    #request.env['warden'].authenticated?(:private) ||
    #  request.env['warden'].authenticated?(:default)
  end
end
