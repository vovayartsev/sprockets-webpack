require 'minitest/spec'
require 'minitest/autorun'
require 'sprockets_require_webpack/file_guard'

describe SprocketsRequireWebpack::FileGuard do
  let(:path) { Pathname.new('/tmp/some_file.txt') }
  before { FileUtils.touch(path) }
  let(:guard) { SprocketsRequireWebpack::FileGuard.new(path.to_s) }

  it 'can be created' do
    guard.must_be_instance_of SprocketsRequireWebpack::FileGuard
  end

  it 'can detect changes' do
    guard.detect_change?.must_equal(false)

    sleep(1)
    FileUtils.touch(path)
    guard.detect_change?.must_equal(true)

    sleep(1)
    guard.detect_change?.must_equal(false)
  end
end
