module SprocketsRequireWebpack
  class FileGuard
    def initialize(path)
      @path = Pathname.new(path)
      @last_mtime = @path.mtime
    end

    def detect_change?
      current_mtime = @path.mtime
      @last_mtime < current_mtime
    ensure
      @last_mtime = current_mtime
    end
  end
end
