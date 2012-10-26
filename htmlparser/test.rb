require 'nokogiri'
require 'open-uri'

#doc = Nokogiri::HTML(open('http://a.m.tmall.com/i10032396923.htm?v=1'))
#doc.css('.promomtion-price').each do |price|
#  puts price.content
#end

doc = Nokogiri::HTML(open('http://pesystem.taobao.org:9999/app/wdetail/'));


hoststable = doc.css('.ks-switchable-content table')[0];

#puts hoststable

hoststable.css("tr").each do |tr|

    tr.css("td").each do  |td|
         print(td.content);
         print(">>>>>");
    end
    puts();
end
