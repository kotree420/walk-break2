require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WalkBreak
  class Application < Rails::Application
    config.api_only = true

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.i18n.default_locale = :ja
    config.active_model.i18n_customize_full_message = true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Asia/Tokyo'
    # config.eager_load_paths << Rails.root.join("extras")

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }

    #Cookies
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
      # domain: :all,
      # tld_length: 2,
      # secure: true
    config.middleware.use ActionDispatch::ContentSecurityPolicy::Middleware
    config.action_dispatch.cookies_same_site_protection = :none
  end
end
