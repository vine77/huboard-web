Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_SECRET'], scope: "read:org,user:email"
end
OmniAuth.config.logger = Rails.logger
