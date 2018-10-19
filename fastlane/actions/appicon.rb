module Fastlane
    module Actions

      class AppiconAction < Action
        def self.run(params)

          icon_sets = Dir.glob(File.join(params[:asset_catalog_path], '*.appiconset'))
          UI.user_error!("Could not find any app icon sets in the specified asset catalog. Please create one first!") unless icon_sets.size > 0

          if icon_sets.size > 1
            UI.message "Select Icon Set: "
            icon_set = choose(*(icon_sets))
          else
            icon_set = icon_sets.first
          end

          contents_file = File.join(icon_set, 'Contents.json')
          contentsJSON = JSON.parse(File.read(contents_file))

          contentsJSON['images'].each do |image|
            image_size = image['size']
            image_scale = image['scale']

            scaled_image_width = Integer(image_size.split('x').first.to_f * image_scale.sub('x', '').to_f)
            scaled_image_name = "Icon-#{image_size}-@#{image_scale}#{File.extname(params[:icon_path])}"
            scaled_image_output = File.join(icon_set, scaled_image_name)

            UI.message "Generating #{image_size} @ #{image_scale} 🎨"
            if system("convert #{params[:icon_path].shellescape} -resize #{scaled_image_width}x#{scaled_image_width} #{scaled_image_output.shellescape}")

              current_icon_name = image['filename']
              if current_icon_name
                current_icon_file = File.join(icon_set, current_icon_name)
                if File.exist?(current_icon_file) and !scaled_image_name.eql?(current_icon_name)
                  FileUtils.rm(current_icon_file)
                end
              end

              image['filename'] = scaled_image_name
            else
              UI.crash!("Failed to run: 'convert #{params[:icon_path].shellescape} -resize #{scaled_image_width}x#{scaled_image_width} #{scaled_image_output.shellescape}'")
            end

          end

          # Save the new Contents.json
          File.open(contents_file, "w") do |file|
            file.write(JSON.pretty_generate(contentsJSON))
          end

          UI.success "Successfully generated and installed the app icons 🎉"
        end

        #####################################################
        # @!group Documentation
        #####################################################

        def self.description
          "Generate and install icons into an Xcode Asset Catalog"
        end

        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :icon_path,
                                         env_name: "FL_APPICON_PATH",
                                         description: "Path to the 1024x1024 iTunes icon png",
                                         is_string: true,
                                         verify_block: proc do |value|
                                            UI.user_error!("Couldn't find the specified icon at path '#{value}'") unless File.exist?(value)
                                         end
                                         ),
            FastlaneCore::ConfigItem.new(key: :asset_catalog_path,
                                         env_name: "FL_ASSET_CATALOG_PATH",
                                         description: "Path to the asset catalog, which holds your *.appiconset",
                                         is_string: true,
                                         verify_block: proc do |value|
                                            UI.user_error!("Couldn't find the specified asset catalog at path '#{value}'") unless File.exist?(value)
                                            UI.user_error!("It seems that you did not specify a valid asset catalog. It needs to be a .xcassets directory.") unless File.directory?(value) and File.extname(value).eql?('.xcassets')
                                         end
                                         )
          ]
        end

        def self.authors
          ["ffittschen"]
        end

        def self.is_supported?(platform)
          true
        end
      end
    end
  end
