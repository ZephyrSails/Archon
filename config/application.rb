require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'mechanize'
require 'logger'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Commander
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.

    config.paths.add 'app/commander', glob: '**/*.rb'
    config.autoload_paths += Dir["#{Rails.root}/app/commander/*"]
    config.eager_load_paths += Dir["#{Rails.root}/app/commander/*"]

    Settings.reload!
    config.after_initialize do

      if ENV['server_mode']
        Captain.one_order_spy
        Captain.one_order_deep_spy
        Captain.one_order_loot
      end
    end

    config.active_record.raise_in_transactional_callbacks = true

  end
end
