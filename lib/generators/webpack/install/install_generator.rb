module Webpack
  class InstallGenerator < Rails::Generators::Base
    desc 'This generator creates an initializer file at config/initializers'

    def self.source_root
      @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end

    def create_barebone_file
      template 'config/webpack.config.js'
      template 'package.json'
    end

    def create_sample_assets
      template 'app/assets/webpack/index.js'
      if File.exist?('app/assets/javascripts/application.js')
        append_to_file 'app/assets/javascripts/application.js' do
          "\n//= require_webpack_tree ../webpack\n"
        end
      else
        puts "WARNING: remember to add //= require_webpack_tree ../webpack to your application.js"
      end
    end

    def adjust_gitignore
      if File.exist?('.gitignore')
        append_to_file '.gitignore', "\nnode_modules\n"
      end
    end

    def adjust_slugignore
      if File.exist?('.slugignore')
        append_to_file '.slugignore', "\nnode_modules\n"
      else
        create_file '.slugignore', "node_modules\n"
      end
    end

    def add_packages
      system 'npm install webpack babel-core babel-loader babel-preset-es2015 babel-preset-react --save'
    end
  end
end
