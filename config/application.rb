require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shumitomo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Tokyo"
    # config.eager_load_paths << Rails.root.join("extras")
    # 日本語化の設定
    config.i18n.default_locale = :ja
    config.active_storage.variable_content_types += ['image/heic', 'image/heic-sequence', 'image/heif', 'image/heif-sequence']
    config.paths.add 'lib', eager_load: true
  end
end
