require_relative '../sprockets_require_webpack/webpack_driver'
require_relative '../sprockets_require_webpack/webpack_error'

module SprocketsRequireWebpack
  class WebpackDirectiveProcessor < Sprockets::DirectiveProcessor
    def process_require_webpack_tree_directive(path = ".")
      absolute_path = expand_relative_dirname(:require_tree, path)
      entry = entry_from_absolute_path(absolute_path)

      add_path_to_dependencies_list(absolute_path)

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
      raise WebpackError, errors.join("\n") if errors.any?
    end

    def entry_from_absolute_path(absolute_path)
      Pathname.new(absolute_path).join('index.js').tap do |entry|
        unless entry.exist?
          raise WebpackError, "#{entry} doesn't exist"
        end
      end
    end

    def webpack_config
      defined?(Rails) ? Rails.root.join('config/webpack.config.js') : 'webpack.config.js'
    end

    def driver_for(entry)
      entry = String(entry)
      $webpack_drivers ||= {}
      $webpack_drivers[entry] ||= WebpackDriver.new(webpack_config, entry)
    end

    def add_path_to_dependencies_list(path)
      require_webpack_paths(*@environment.stat_sorted_tree_with_dependencies(path))
    end

    def require_webpack_paths(paths, deps)
      # this adds files to "dependencies" list as a side effect
      resolve_paths(paths, deps, accept: @content_type, pipeline: :self) do |uri|
      end
    end

    def logger
      defined?(Rails) ? Rails.logger : stderr_logger
    end

    def stderr_logger
      @stderr_logger ||= Logger.new(STDERR)
    end
  end
end