
Rails.application.middleware.insert_after ActionDispatch::Flash, Warden::Manager do |config|

  config.scope_defaults :default, strategies: [:github],
    config: {
    client_id:     ENV["GITHUB_CLIENT_ID"],
    client_secret: ENV["GITHUB_SECRET"],
    scope:         'read:org,user:email'
  }

  config.scope_defaults :public, strategies: [:github],
    config: {
    client_id:     ENV["GITHUB_PUBLIC_CLIENT_ID"],
    client_secret: ENV["GITHUB_PUBLIC_SECRET"],
    scope:         'read:org,user:email,public_repo',
    redirect_uri: '/auth/github_public/callback'
  }

  config.scope_defaults :private, strategies: [:github],
    config: {
    client_id:     ENV["GITHUB_PRIVATE_CLIENT_ID"],
    client_secret: ENV["GITHUB_PRIVATE_SECRET"],
    scope:         'read:org,user:email,repo',
    redirect_uri: '/auth/github_private/callback'
  }

  config.failure_app = Rails.application.routes

end


Warden::Manager.serialize_from_session { |key| Warden::GitHub::Verifier.load(key) }
Warden::Manager.serialize_into_session { |user| Warden::GitHub::Verifier.dump(user) }

