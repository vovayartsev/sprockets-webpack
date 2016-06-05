require 'pathname'
require 'benchmark'
require_relative './file_guard'

module SprocketsRequireWebpack
  class WebpackDriver
    def initialize(config, entry)
      @tempfile = Tempfile.new("bundle.XXXXXXXXX.js")
      @config_guard = FileGuard.new(config)
      cmd = "node #{compiler_js_path} #{config} #{entry} #{path.dirname} #{path.basename} 2>&1"
      @io = IO.popen({'NODE_ENV' => env}, cmd, 'r+')
    end

    def compile
      errors = []

      @io.puts(@config_guard.detect_change? ? 'RELOAD' : '')  # starts compilation

      bm = Benchmark.measure do
        while (line = read_line.strip) != 'WEBPACK::EOF' do
          errors << line
        end
      end

      OpenStruct.new(errors: errors, data: path.read, benchmark: bm)
    rescue Errno::EPIPE, IOError
      errors.unshift '----- NODE BACKTRACE -----'
      errors.unshift "#{$!.message}. Please check webpack.conf.js and restart web server"
      errors.unshift
      OpenStruct.new(
          errors: errors,
          data: 'console.error("Broken pipe. Webpack died.")',
          benchmark: "<#{@io.pid} died>")
    end

    private

    def read_line
      @io.gets or raise IOError, 'Webpack died'
    end

    def env
      ENV.fetch('NODE_ENV') do
        defined?(Rails) ? Rails.env : (ENV['RACK_ENV'] || 'development')
      end
    end

    def compiler_js_path
      Pathname.new(__FILE__).dirname.join('compiler.js')
    end

    def path
      @path ||= Pathname.new(@tempfile.path)
    end
  end
end
