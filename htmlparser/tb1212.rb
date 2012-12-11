#!/usr/bin/ruby

require 'open-uri'
require 'optparse'
require "nokogiri"

config = ""!
OptionParser.new do |opts|
  opts.banner = "Usage: your id file"
  opts.on("--config serverlist", "input your serverlist confirg") do |v|
    config = v
  end
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

puts config
File.open(config, "r").each_line do |line|

  if !line.nil?
    id = line.strip;
    doc = Nokogiri::HTML(open('http://a.m.taobao.com/i' + id + ".htm?v=1"));
    price = doc.css("body>.bd>.box>.detail>p>img+strong");
    if(price.length > 0)
      puts "%s       %s" % [id, price[0].content]
    end

  end
end