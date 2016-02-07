class User < Struct.new(:attribs, :token) 

  ATTRIBUTES = %w[id login name gravatar_id avatar_url email company site_admin].freeze

  extend ApplicationHelper
  def self.load(document, scope=:default)
    data = { } 

    document.omniauth[scope]['extra']['raw_info'].to_hash.each do |k, v|
      data[k.to_s] = v if ATTRIBUTES.include?(k.to_s)
    end

    new(data, document.omniauth[scope]["credentials"]["token"])
  end
  def id
    attribs["uid"]
  end

  def safe_avatar_url
    return attribs['avatar_url'] unless attribs['avatar_url'].nil?
    "https://secure.gravatar.com/avatar/" + attribs['gravatar_id'] + "?d=retro"
  end

  def marshal_dump
    Hash[members.zip(values)]
  end

  def marshal_load(hash)
    hash.each { |k,v| send("#{k}=", v) }
  end

  ATTRIBUTES.each do |name|
    define_method(name) { attribs[name] }
  end

  def self.find_or_create_from_omniauth(auth_hash, scope=:default)
    attributes = ::Hashie::Mash.new({
      uid: auth_hash.uid,
      omniauth: {
    }
    })

    attributes[:omniauth][scope] = auth_hash

    user = couch.user.find_by_uid attributes.uid
    if user.nil?
      user = couch.user.get_or_create attributes
      self.load(user)
    else
      user[:omniauth][scope] = auth_hash
      doc = couch.user.save user
      self.load doc
    end
  end
end
