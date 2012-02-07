Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 'KEY', 'SECRET'
end