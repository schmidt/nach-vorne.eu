set :username,   ENV["USER"]
set :host,       "nach-vorne.eu"

set :remote_dir, "/var/www/nossl/nachvorne_de"
set :local_dir,  File.join(File.dirname(__FILE__), "_site")

desc "Remove remote files"
task :cleanup, :hosts => "#{username}@#{host}" do
  run "rm -rf #{remote_dir}/*"
end

desc "Upload files"
task :copy, :hosts => "#{username}@#{host}" do
  upload local_dir, remote_dir, :via => :scp, :recursive => true
end

desc "Upload files"
task :clean_copy, :hosts => "#{username}@#{host}" do
  cleanup
  copy
desc 'Remove all generated files'
task :cleanup do
  rm_rf '_sites/*'
end

desc 'Generate all pages'
task :build do
  sh 'jekyll'
end

desc 'Upload all pages'
task :upload do
  sh 'cap copy'
end

desc 'Generate and upload the site'
task :deploy => [:cleanup, :build, :upload]

task :default => :deploy
end
