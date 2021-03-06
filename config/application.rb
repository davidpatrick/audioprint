require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(:default, Rails.env)
end

module Audioprint
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)
    config.assets.enabled = true
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]
    # Enable escaping HTML in JSON.
    config.active_record.whitelist_attributes = true
    config.active_support.escape_html_entities_in_json = true

    config.secret_key_base = 'Audioprint Music'
    config.force_ssl = false

    config.assets.precompile << Proc.new do |path|
      if path =~ /\.(css|js)\z/
        full_path = Rails.application.assets.resolve(path).to_path
        app_assets_path = Rails.root.join('app', 'assets').to_path
        if full_path.starts_with? app_assets_path
          puts "including asset: " + full_path
          true
        else
          puts "excluding asset: " + full_path
          false
        end
      else
        false
      end
    end
  end
end

# State::NAMES
class State
  NAMES = [
    [ "Alabama", "AL" ],
    [ "Alaska", "AK" ],
    [ "Arizona", "AZ" ],
    [ "Arkansas", "AR" ],
    [ "California", "CA" ],
    [ "Colorado", "CO" ],
    [ "Connecticut", "CT" ],
    [ "Delaware", "DE" ],
    [ "District Of Columbia", "DC" ],
    [ "Florida", "FL" ],
    [ "Georgia", "GA" ],
    [ "Hawaii", "HI" ],
    [ "Idaho", "ID" ],
    [ "Illinois", "IL" ],
    [ "Indiana", "IN" ],
    [ "Iowa", "IA" ],
    [ "Kansas", "KS" ],
    [ "Kentucky", "KY" ],
    [ "Louisiana", "LA" ],
    [ "Maine", "ME" ],
    [ "Maryland", "MD" ],
    [ "Massachusetts", "MA" ],
    [ "Michigan", "MI" ],
    [ "Minnesota", "MN" ],
    [ "Mississippi", "MS" ],
    [ "Missouri", "MO" ],
    [ "Montana", "MT" ],
    [ "Nebraska", "NE" ],
    [ "Nevada", "NV" ],
    [ "New Hampshire", "NH" ],
    [ "New Jersey", "NJ" ],
    [ "New Mexico", "NM" ],
    [ "New York", "NY" ],
    [ "North Carolina", "NC" ],
    [ "North Dakota", "ND" ],
    [ "Ohio", "OH" ],
    [ "Oklahoma", "OK" ],
    [ "Oregon", "OR" ],
    [ "Pennsylvania", "PA" ],
    [ "Rhode Island", "RI" ],
    [ "South Carolina", "SC" ],
    [ "South Dakota", "SD" ],
    [ "Tennessee", "TN" ],
    [ "Texas", "TX" ],
    [ "Utah", "UT" ],
    [ "Vermont", "VT" ],
    [ "Virginia", "VA" ],
    [ "Washington", "WA" ],
    [ "West Virginia", "WV" ],
    [ "Wisconsin", "WI" ],
    [ "Wyoming", "WY" ]
  ]
end