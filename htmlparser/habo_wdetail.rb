#!/usr/bin/ruby

require 'mechanize'
require 'nokogiri'
require 'optparse'

$options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: wdetail habo monitor [options]"

  opts.on("-c", "use color mode") do |v|
    $options[:color] = true
  end

  opts.on("-d", "use background mode") do |v|
    $options[:bg] = true
  end
end.parse!

if ARGV.length != 2
  puts "add your username and password";
  exit;
end

class Habo
  def self.get(agent, url)
    page = agent.get(url)
    login_form = page.form_with(:id => 'login-form')
    if login_form
      login_form.id=ARGV[0]
      login_form.pass_word=ARGV[1]
      page = agent.submit(login_form, login_form.buttons.first)
    end
    return page
  end

  def self.getContent(td)
    _content = td.content;
    return _content = _content.strip if !_content.nil?;
  end

  def self.getServerHost(host)
    return host.split("/")[0].match(/([a-z0-9\.]*)/)[0]
  end

end

class HaboData
  attr_accessor :qps
  attr_accessor :rt
  attr_accessor :host
  attr_accessor :load

  def to_s
    str = "%14s %-4s %-6s %-6s" % [host, load, rt, qps]
    ($options[:color] && (Float(load) > 4.0 || Float(rt) > 200)) ? red(str) : str
  end

  def red(message)
    color = '31;1'
    return "\e[#{color}m#{message}\e[0m"
  end
end


$wdetail_monitor_url='http://monitor.taobao.com/monitorportal/main/pointInfo/performancePointList.htm?confId=972&moduleName=performance'
$wdetail_monitor_load='http://monitor.taobao.com/monitorportal/main/pointInfo/devicePointList.htm?confId=972&moduleName=device'
$agent = Mechanize.new
$error_times = 0;
$_map = {}

def do_monitor
  doc = Nokogiri::HTML(Habo.get($agent, $wdetail_monitor_url).body);
  hoststable = doc.css('table#diyReportOne_tops tbody');

  begin
    hoststable.css("tr").each do |tr|
      tds = tr.css("td");
      key = Habo.getServerHost(Habo.getContent(tds[0]))

      data = HaboData.new
      data.host= key
      data.qps= Habo.getContent(tds[1])
      data.rt= Habo.getContent(tds[2])
      $_map[key] = data
    end
    $error_times = 0;
  rescue
    $error_times +=1
    puts 'get rt exception'
  end

  doc = Nokogiri::HTML(Habo.get($agent, $wdetail_monitor_load).body);
  hoststable = doc.css('table#diyReportOne_tops tbody');

  begin
    hoststable.css("tr").each do |tr|
      tds = tr.css("td");
      key = Habo.getServerHost(Habo.getContent(tds[0]))
      if $_map[key]
        $_map[key].load = Habo.getContent(tds[2])
      else
        HaboData data = HaboData.new
        data.host= key
        data.load = Habo.getContent(tds[2])
      end
    end
  rescue
    $error_times +=1
    puts 'get load exception'
  end

  if $error_times == 0
    $_map.each_pair do |key, value|
      p value
    end
  end
  $_map = {}
end

if $options[:bg]
  while $error_times < 1000 do

    do_monitor
  # update time
    sleep 60
  end
else
  do_monitor
end

