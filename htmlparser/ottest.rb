#!/usr/bin/ruby

require 'open-uri'
require 'optparse'

baseUrl, config, match,app = ""
timeInterval = 0;

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: wdetail habo monitor [options]"
  opts.on("--url testurl", "input your testUrl") do |v|
    baseUrl = v
  end
  opts.on("--config serverlist", "input your serverlist confirg") do |v|
    config = v
  end
  opts.on("--match matchstr", "input your match char") do |v|
    match = v
  end
  opts.on("--app app", "input your appName") do |v|
    app = v
  end
  opts.on("--timeInterval loop", "run as demon , time interval") do |v|
    timeInterval = v.to_i
  end
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end

begin
  optparse.parse!
  if !baseUrl || !config || !match
    puts optparse
    exit
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts optparse
  exit
end

def red(message)
  color = '31;1'
  "\e[#{color}m#{message}\e[0m"
end


while true

  errorHosts = [];

  file = File.open(config, "r").each_line do |line|

    host = line.strip
    if !app.empty? && host !~ /^wdetail/
      host = app + host;
    end

    if host !~ /\.pre\./
      othost = baseUrl.gsub(/http:\/\/.*\//, "http://"+host+".ot.m.taobao.com/")
      html = '';
      begin
        open(othost) do |content|
          content.each_line { |str| html += str }
        end
      rescue
      end

      if !html.include?(match)
        errorHosts.push(host)
        puts red(host);
      else
        puts host;
      end
    end
    #p line.strip
  end

  errorHosts.each do |h|
    begin
      system("notify-send " + h )
    rescue
    puts (">>>>" + h)
    end
  end


  if(timeInterval > 0)
    sleep(timeInterval);
  else
    exit;
  end

end



