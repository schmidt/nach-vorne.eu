set :username,   ENV["USER"]
set :host,       "nach-vorne.eu"

set :remote_dir, "/var/www/nossl/nachvorne_de"
set :local_dir,  File.join(File.dirname(__FILE__), "_site")


desc "Upload files"
task :copy, :hosts => "#{username}@#{host}" do
  run "rm -rf #{remote_dir}/*"
  upload local_dir, remote_dir, :via => :scp, :recursive => true
end
