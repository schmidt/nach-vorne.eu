host       = "beta.nach-vorne.eu"
remote_dir = "/var/www/nossl/www.nach-vorne.eu"
local_dir  = File.join(File.dirname(__FILE__), "_site")

desc "Remove remote files"
task :cleanup do
  sh "ssh #{host} rm -rf #{remote_dir}/*"
end

desc "Upload files"
task :copy do
  sh "scp -r #{local_dir} #{host}:#{remote_dir}"
end

desc "Upload files"
task :clean_copy => [:cleanup, :copy]
