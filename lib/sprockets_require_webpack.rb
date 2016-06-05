require 'sprockets'
require_relative 'sprockets_require_webpack/webpack_directive_processor'

if defined?(Rails)
  module SprocketsRequireWebpack
    class Railtie < ::Rails::Railtie
      config.to_prepare do
        ENV['NODE_PATH'] ||= String(Rails.root.join('node_modules'))
        Sprockets.unregister_processor('application/javascript', Sprockets::DirectiveProcessor)
        Sprockets.register_processor('application/javascript', WebpackDirectiveProcessor)
      end
    end
  end
end
