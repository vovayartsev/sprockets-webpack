require 'pathname'
require 'benchmark'

module SprocketsRequireWebpack
  class WebpackDriver
    def initialize(config, entry)
      @tempfile = Tempfile.new("bundle.XXXXXXXXX.js")

      cmd = "node #{compiler_js_path} #{config} #{entry} #{path.dirname} #{path.basename}"
      @io = IO.popen(cmd, 'r+')
    end

    def compile
      @io.puts # start compilation

      errors = []

      bm = Benchmark.measure do
        while ((line = @io.gets.strip) != 'WEBPACK::EOF') do
          errors << line
        end
      end

      OpenStruct.new(errors: errors, data: path.read, benchmark: bm)
    rescue Errno::EPIPE
      OpenStruct.new(
          errors: ['Broken pipe. Webpack died', 'Please check STDERR and restart web server'],
          data: 'console.error("Broken pipe. Webpack died.")',
          benchmark: "<#{@io.pid} died>")
    end

    private

    def compiler_js_path
      Pathname.new(__FILE__).dirname.join('compiler.js')
    end

    def path
      @path ||= Pathname.new(@tempfile.path)
    end
  end
end