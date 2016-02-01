class User
  extend ApplicationHelper
  def self.find_or_create_from_omniauth(auth_hash, scope=:default)
    attributes = ::Hashie::Mash.new({
      uid: auth_hash.uid,
      omniauth: {
      }
    })

    attributes[:omniauth][scope] = auth_hash

    user = couch.user.find_by_uid attributes.uid
    binding.pry
    if user.nil?
      user = couch.user.get_or_create attributes
    else
      user[:omniauth][scope] = auth_hash
      couch.user.save user
    end
  end
end
