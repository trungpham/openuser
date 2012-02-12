class IdentityConfig
  class << self
    def init
      @override = {}
      @original = YAML.load(File.open(Rails.root.join('config', 'identity.yml')))
    end
    def set(provider, config)
      _provider = provider.to_sym
      @override[_provider] = config
    end
    def get(provider)
      _provider = provider.to_sym
      @override[_provider] || @original[_provider]
    end
  end
end

IdentityConfig.init

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, IdentityConfig.get(:facebook)[:app_id], IdentityConfig.get(:facebook)[:app_secret], :display => 'popup', :client_options => {:ssl => {:ca_file => Rails.root.join('certs', 'cacert.pem').to_s}}
end