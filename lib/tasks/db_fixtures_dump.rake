# Original from http://snippets.dzone.com/posts/show/4468 by MichaelBoutros
#
# Optimized version which uses to_yaml for content creation and checks
# that models are ActiveRecord::Base models before trying to fetch
# them from database.

# Then forked from https://gist.github.com/iiska/1527911
#
# fixed obsolete use of RAILS_ROOT, glob
# allow to specify output directory by FIXTURES_PATH

# Forked to https://github.com/wearefine/db_fixtures_dump for tweaks and personal preferences

require 'fixture_dumper'
namespace :db do
  namespace :fixtures do
    desc 'Dumps all models into fixtures.'
    task :dump => :environment do
      options = {fixtures_path: ENV['FIXTURES_PATH'], exclude_models: ENV['EXCLUDE_MODELS']}
      FixtureDumper.dump(options)
    end
  end
end