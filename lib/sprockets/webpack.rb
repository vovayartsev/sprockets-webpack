require 'sprockets'
require_relative 'webpack/webpack_directive_processor'

module Sprockets
  module Webpack
    if defined?(::Rails)
      class Railtie < ::Rails::Railtie
        config.to_prepare do
          ENV['NODE_PATH'] ||= String(::Rails.root.join('node_modules'))
          Sprockets.unregister_processor('application/javascript', Sprockets::DirectiveProcessor)
          Sprockets.register_processor('application/javascript', WebpackDirectiveProcessor)
        end
      end
    end
  end
end
