#!/usr/bin/env ruby

require 'csv'
require 'rubygems'
require 'twitter-text'

class Tweet < Struct.new(:date, :time, :long_text, :url)
  include Twitter::Autolink

  def html_text
    auto_link text
  end

  def text
    long_text["schmidtwisser: ".length..-1]
  end
end


# read
tweets = []
CSV.foreach('tweets.csv') do |row|
  tweets << Tweet.new(*row)
end

# filter @-replies
tweets.delete_if { |t| t.text =~ /^@/ }

# write files
tweets.group_by(&:date).each do |date, blobs|
  File.open("_posts/#{date}-blobs.html", 'w') do |f|
    text = blobs.map do |blob|
      %Q{
<blockquote><p>#{blob.html_text}</p></blockquote>
<p><a href="#{blob.url}">[#{blob.time[0..4]}]</a></p>
}
    end.join("\n<hr />\n")

    f.puts %Q{
---
title    : "Blobs - #{date}"
layout   : blob
category : blob
---
{% include JB/setup %}

#{text}
}
  end
end
