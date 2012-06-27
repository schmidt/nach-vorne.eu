set :host,       "gamma.nach-vorne.eu"

set :remote_dir, "/var/www/blog.schm.eu"
set :local_dir,  File.join(File.dirname(__FILE__), "_site")

desc "Remove remote files"
task :cleanup, :hosts => host do
  run "rm -rf #{remote_dir}/*"
end

desc "Upload files"
task :copy, :hosts => host do
  upload local_dir, remote_dir, :via => :scp, :recursive => true
end

desc "Upload files"
task :clean_copy, :hosts => host do
  cleanup
  copy
end
