desc "Pull migrations from vault HEAD"
task :pull_vault_schema do
  steps = []
  steps << 'cd contrib/'
  if File.exists?('contrib/vault')
    steps << 'rm -rf vault'
  end
  steps << 'git clone -n git@github.com:heroku/vault --depth 1'
  steps << 'cd vault'
  steps << 'git checkout HEAD db/migrations/*'
  # make sure we don't submodule it
  steps << 'rm -rf .git'
  sh steps.join(' && ')
end

desc "Drop and recreate vault-test database"
task :create_vault_db => [:drop_vault_db] do
  sh 'createdb vault-test'
  sh 'sequel -m contrib/vault/db/migrations postgres:///vault-test'
end

desc "Drop the vault-test database"
task :drop_vault_db do
  sh 'dropdb vault-test || true'
end
