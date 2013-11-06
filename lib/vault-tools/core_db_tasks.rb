# Rake tasks for Core DB
#
# include in Rakefile via:
#
# require 'vault-tools/core_db_tasks'

desc "Pull db/structure.sql from api HEAD"
task :pull_core do
  steps = []
  steps << 'cd contrib/'
  if File.exists?('contrib/core')
    steps << 'rm -rf core'
  end
  steps << 'git clone -n git@github.com:heroku/api --depth 1'
  steps << 'cd core'
  steps << 'git checkout HEAD db/structure.sql'
  # make sure we don't submodule it
  steps << 'rm -rf .git'
  sh steps.join(' && ')
end

desc "Drop and recreate the core-test database"
task :create_core_db => [:drop_core_db, :pull_core] do
  sh 'createdb core-test'
  sh 'psql core-test -f contrib/core/db/structure.sql'
end

desc "Drop the core-test database"
task :drop_core_db do
  sh 'dropdb core-test || true'
end
