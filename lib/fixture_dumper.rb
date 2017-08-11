class FixtureDumper

  @@exclude_models = ''
  @@skipped_models = []

  class << self

    def dump(options)
      @@exclude_models   = options[:exclude_models] || ''
      fixtures_directory = options[:fixtures_directory] || "test/fixtures/"
      models             = get_app_models
      fae_models         = ['Fae::StaticPage','Fae::TextArea','Fae::TextField']

      models += fae_models

      puts "Found models: " + models.join(', ')
      puts "Dumping to: " + fixtures_directory

      models.each do |m|
        model = m.constantize
        fixture_file = Rails.root + (fixtures_directory + model.name.underscore.pluralize.gsub('fae/','') + '.yml')

        next if skipped_and_logged_model?(model)

        dump_fixture(model,fixture_file)

      end
      puts "Skipped: #{@@skipped_models.sort.join(', ')}"
    end

    private

    def get_app_models
      Dir.glob(Rails.root + 'app/models/**.rb').map do |s|
        Pathname.new(s).basename.to_s.gsub(/\.rb$/,'').camelize
      end
    end

    def skipped_and_logged_model?(model)
      if !model.ancestors.include?(ActiveRecord::Base) || model.name == 'ApplicationRecord' || @@exclude_models.include?(model.name)
        @@skipped_models << model.name
        return true
      end
      false
    end

    def dump_fixture(model,fixture_file)
      if !::File::file?(fixture_file)
        entries = model.unscoped.all.order('id ASC')
        puts "Dumping model: #{model.name} (#{entries.length} entries)"
        output = {}
        entries.each_with_index do |e,i|
          attrs = e.attributes
          attrs.delete_if{|k,v| v.nil?}

          output["#{model.name}_#{i}"] = attrs
        end
        file = File.open(fixture_file, 'w')
        file << output.to_yaml
        file.close
      else
        puts "Fixture exists: #{model.name}"
      end
    end

  end

end