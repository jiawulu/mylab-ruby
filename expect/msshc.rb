#!/usr/bin/ruby

require "net/ssh"
require 'net/scp'
require 'optparse'

$options = {:username => ENV['SSHD_USERNAME'], :password => ENV['SSHD_PASSWORD']}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: wdetail habo monitor [options]"
  opts.on("-u username", "input your username") do |v|
    $options[:username] = v
  end
  opts.on("-p password", "input your password") do |v|
    $options[:password] = v
  end
  opts.on("--up file", "input your upload file") do |v|
    $options[:up] = v
  end
  opts.on("--down file", "input your download file") do |v|
    $options[:down] = v
  end
  opts.on("--cmd cmd", "input your cmd") do |v|
    $options[:cmd] = v
  end
  opts.on("--config serverlist", "input your serverlist confirg") do |v|
    $options[:config] = v
  end
  opts.on("--host host", "input your host") do |v|
    $options[:host] = v
  end
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end

class SSHC
  def self.execute(host, config)
    begin
    Net::SSH.start(host, config[:username], :password => config[:password]) do |ssh|

      if config[:up]
        puts config[:up]
        ssh.scp.upload!(config[:up], '.')
      elsif config[:down]
        ssh.scp.download!(config[:down], ".")
      else
        ssh.open_channel do |channel|
          channel.request_pty
          channel.exec(config[:cmd]) do |ch, data|
            channel.on_data do |ch, data|
              puts data
              if data =~ /assword/
                channel.send_data password
              elsif data =~ /bash/
                channel.send_data "exit"
              else
                channel.send_data "\n"
              end
            end
          end
        end
      end
    end
    rescue

    end
    end
end


begin
  optparse.parse!
  if  ($options[:up] || $options[:down] || $options[:cmd]) && ( $options[:config] || $options[:host] )
  else
    puts "usage"
    puts "./msshc.rb --up hello.vm --host wdetail.cm3 "
    puts './msshc.rb --cmd "sudo -u admin -H cp hello.vm ../admin/wdetail/target/wdetail.war/templates/screen/" '
    puts optparse
    exit
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts optparse
  exit
end


if $options[:config]
  File.open($options[:config], "r").each_line do |line|
    host = line.strip
    SSHC.execute(host, $options)
  end
elsif $options[:host]
  puts 1111;
  SSHC.execute($options[:host].strip, $options)
end






