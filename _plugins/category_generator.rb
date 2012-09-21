module Jekyll
  class CategoryGenerator < Jekyll::Generator
    safe true
    priority :lowest

    def generate(site)
      categories = {}

      site.posts.each do |post|
        post.categories.each do |cat|
          categories[cat] ||= []
          categories[cat].unshift post
        end
      end

      # Access this in Liquid using: site._cat_name
      categories.each do |cat, posts|
        site.config["#{cat}_posts"] = posts
      end
    end
  end
end

