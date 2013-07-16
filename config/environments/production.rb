Audioprint::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

  # Precompile additional assets
  config.assets.precompile += %w( .svg .eot .woff .ttf )

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'example.com' }
  # ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"


  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "gmail.com",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: 'audioprintweb@gmail.com',
    password: 'ch33s3danish'
  }
  PAPERCLIP_BLOG_OPTS = {
    :styles => { :large => "1150x292!", :medium => "575x146!" },
    :url => "/assets/blogs/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/blogs/:id/:style/:basename.:extension"
  }
  PAPERCLIP_IMAGE_OPTS = {
    :styles => { :large => "400x400!", :medium => "300x300!", :small => "200x200!", :thumb => "100x100!" },
    :url => "/assets/albums/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/albums/:id/:style/:basename.:extension",
    :default_url => "/assets/missing-cover.png"
  }
  PAPERCLIP_AVATAR_OPTS = {
    :styles => { :large => "400x400>", :medium => "300x300>", :small => "150x150>", :thumb => "100x100>" },
    :url => "/assets/avatars/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/avatars/:id/:style/:basename.:extension"
  }
  PAPERCLIP_MP3_OPTS = {
    :url => ':s3_domain_url',
    :storage        => :s3,
    :s3_permissions => :private,
    :s3_protocol => 'http',
    :s3_credentials => {
      :bucket => 'audioprint_development',
      :access_key_id => 'AKIAIYEFQSJPIGAZ3OJA',
      :secret_access_key => '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'
    },
    :path => '/:attachment/:id/:style/:basename.:extension'
  }


  # config.action_mailer.smtp_settings = {
  #   address: "smtp.gmail.com",
  #   port: 587,
  #   domain: "gmail.com",
  #   authentication: "plain",
  #   enable_starttls_auto: true,
  #   user_name: ENV["GMAIL_USERNAME"],
  #   password: ENV["GMAIL_PASSWORD"]
  # }
  # PAPERCLIP_BLOG_OPTS = {
  #   :styles => { :large => "784x496>", :medium => "517x327>", :thumb => "258x163>" },
  #   :storage        => :s3,
  #   :s3_protocol => 'http',
  #   :s3_credentials => {
  #     :bucket => 'audioprint_assets',
  #     :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  #     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  #   },
  #   :path           => 'blogs/:id/:attachment/:style.:extension',
  #   :processor       => [ :cropper ]
  # }
  # PAPERCLIP_IMAGE_OPTS = {
  #   :styles => { :large => "400x400!", :medium => "300x300!", :thumb => "100x100!"  },
  #   :storage        => :s3,
  #   :s3_protocol => 'http',
  #   :s3_credentials => {
  #     :bucket => 'audioprint_cover_art',
  #     :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  #     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  #   },
  #   :path           => 'albums/:id/:attachment/:style.:extension',
  #   :processor       => [ :cropper ],
  #   :default_url => "/assets/missing-cover.png"
  # }
  # PAPERCLIP_AVATAR_OPTS = {
  #   :styles => { :large => "400x400!", :medium => "300x300!", :small => "150x150!", :thumb => "100x100!" },
  #   :storage        => :s3,
  #   :s3_protocol => 'http',
  #   :s3_credentials => {
  #     :bucket => 'audioprint_assets',
  #     :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  #     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  #   },
  #   :path           => 'users/:id/:attachment/:style.:extension',
  #   :processor       => [ :cropper ]
  # }
  # PAPERCLIP_MP3_OPTS = {
  #   :url => ':s3_domain_url',
  #   :storage        => :s3,
  #   :s3_permissions => :private,
  #   :s3_protocol => 'http',
  #   :s3_credentials => {
  #     :bucket => 'audioprint_mp3s',
  #     :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  #     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  #   },
  #   :path => '/:attachment/:id/:style/:basename.:extension'
  # }


  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
end
