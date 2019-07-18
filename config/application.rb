require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HomoLudensNw
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # 標準は世界時間なので、東京の時間に直す。
    config.time_zone = 'Tokyo'
    # DBに書かれる時間も日本時間に変更する。
    config.active_record.default_timezone = :local

    # エラーメッセージを日本語化する
    config.i18n.default_locale = :ja

    # config/locales以下のディレクトリ内にある全てのymlファイルを読み込む
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
  end
end
