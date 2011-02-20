module Rich
  module Cms
    class Engine < Rails::Engine

      class RichCmsError < StandardError
      end

      class << self

        def init
          append_to_load_path
          setup_assets
        end

      private

        def append_to_load_path
          %w(controllers).each do |dir|
            path = File.join File.dirname(__FILE__), "..", "..", "app", dir
            $LOAD_PATH << path
            ActiveSupport::Dependencies.autoload_paths << path
            ActiveSupport::Dependencies.autoload_once_paths.delete path
          end
        end

        def setup_assets
          procedure = proc {
            ::Jzip::Engine.add_template_location({File.expand_path("../../../../assets/jzip", __FILE__) => File.join(Rails.root, "public", "javascripts")})
            ::Sass::Plugin.add_template_location( File.expand_path("../../../../assets/sass", __FILE__),   File.join(Rails.root, "public", "stylesheets") )
            copy_images
          }

          if Rails::VERSION::MAJOR >= 3
            config.after_initialize do
              procedure.call
            end
          else
            procedure.call
          end
        end

        def copy_images
          return if Rails.env == "test"

          source_dir = File.join File.dirname(__FILE__), "..", "..", "..", "assets", "images", "."
          target_dir = File.join Rails.root, "public", "images", "rich", "cms"

          FileUtils.rm_r    target_dir if File.exists? target_dir
          FileUtils.mkdir_p target_dir
          FileUtils.cp_r    source_dir, target_dir
        end

      end

    end
  end
end

Rich::Cms::Engine.init