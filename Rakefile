task :default do
  Dir['*.md'].each do |name|
    next if name =~ /README/
    base = name.split('.')[0..-2].join('.')
    path = "slides/" + base

    unless File.exist? path
      FileUtils.mkdir_p path
    end

    sh "bundle exec slideshow -t shower -o #{path} #{name}"

    FileUtils.cd path do
      FileUtils.mv "#{base}.html", "index.html"
    end
  end
end
