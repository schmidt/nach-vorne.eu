task :default do
  Dir['*.md'].each do |name|
    next if name =~ /README/
    base = name.split('.')[0..-2].join('.')

    unless File.exist? base
      FileUtils.mkdir_p base
    end

    sh "bundle exec slideshow -t shower -o #{base} #{name}"

    FileUtils.cd base do
      FileUtils.mv "#{base}.html", "index.html"
    end
  end
end
