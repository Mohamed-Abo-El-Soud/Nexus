require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Nexus
  class Application < Rails::Application
    
    # set response upon errors
    config.action_view.field_error_proc = Proc.new do |html_tag, instance| 
      n_node = Nokogiri::HTML html_tag
      if n_nade.css('input').any?
        n_nade.css('input').tap{ |ns| ns.add_class('error-field') }
      end
      puts html_tag#.class.name
      # puts html_tag#.methods
      #instance#"#{html_tag}"
      # page = Nokogiri::HTML
      # script = "<script id='error-loading-jquery-script'>
        # console.log($('#error-loading-jquery-script').parent().children('input'));</script>"
      # "<div class=\"field_with_moo\">#{script}#{html_tag}</div>".html_safe
      "#{html_tag}".html_safe
    end
    
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
    config.active_record.raise_in_transactional_callbacks = true
  end
end
