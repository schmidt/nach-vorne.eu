task :default do
  Dir['*.md'].each do |name|
    next if name =~ /README/
    sh "bundle exec slideshow -t shower #{name}"
  end
end
