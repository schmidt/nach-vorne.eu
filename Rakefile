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
