require_relative './webpack_driver'
require_relative './webpack_error'

module Sprockets
  module Webpack
    class WebpackDirectiveProcessor < Sprockets::DirectiveProcessor
      def process_require_webpack_tree_directive(path = '.')
        absolute_path = expand_relative_dirname(:require_tree, path)
        entry = entry_from_absolute_path(absolute_path)

        add_path_to_dependencies_list(absolute_path)
        add_webpack_config_to_dependencies_list

        compiled = driver_for(entry).compile
        logger.info "WEBPACK: #{compiled.benchmark}"

        assert_no_errors(compiled.errors)

        @webpack_data = compiled.data
      end

      def _call(_)
        result = super
        super.merge(data: result[:data] + "\n\n\n" + @webpack_data)
      end

      private

      def assert_no_errors(errors)
        fail WebpackError, errors.join("\n") if errors.any?
      end

      def entry_from_absolute_path(absolute_path)
        Pathname.new(absolute_path).join('index.js').tap do |entry|
          fail WebpackError, "#{entry} doesn't exist" unless entry.exist?
        end
      end

      def webpack_config
        defined?(::Rails) ? ::Rails.root.join('config/webpack.config.js') : 'webpack.config.js'
      end

      def driver_for(entry)
        entry = String(entry)
        $webpack_drivers ||= {}
        $webpack_drivers[entry] ||= WebpackDriver.new(webpack_config, entry)
      end

      def add_path_to_dependencies_list(path)
        require_webpack_paths(*@environment.stat_sorted_tree_with_dependencies(path))
      end

      def add_webpack_config_to_dependencies_list
        @dependencies << "file-digest://#{webpack_config}"
      end

      def require_webpack_paths(paths, deps)
        # this adds files to "dependencies" list as a side effect
        resolve_paths(paths, deps, accept: @content_type, pipeline: :self) do |_uri|
        end
      end

      def logger
        defined?(::Rails) ? ::Rails.logger : stderr_logger
      end

      def stderr_logger
        @stderr_logger ||= Logger.new(STDERR)
      end
    end
  end
end
