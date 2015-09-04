require 'pry'
require 'httparty'
puts "Yaml URL:"
url = gets.chomp
response = HTTParty.get(url)

yaml_content = response.body
yamarray = yaml_content.split("\n")
yamarray.delete_if do |item| 
  item.include?("uuid") || item.include?("contents") || item.match(/^\s{16}\S/)
end
trackname = yamarray[2].gsub("    title: ","")
yamarray.slice!(0..2)
newyamarray = yamarray.collect { |item| item.gsub("-   ","")  }


csv = "Type, Title,Lesson URL\n"
newyamarray.each do |item|
  if item.match(/^\s{4}title/)
    csv += "TOPIC,#{item.strip.gsub('title: ',"")},\n"
  elsif item.match(/^\s{8}title/)
    csv += "UNIT,#{item.strip.gsub('title: ',"")},\n"
  elsif item.match(/^\s{12}title/)
    csv += "LESSON,#{item.strip.gsub('title: ',"")}," 
  elsif item.match(/source:/)
      csv += "#{item.strip.gsub("source: ","")}\n" 
  end
end

fname = "#{trackname.gsub(" ","-")}.csv"
output = File.open(fname, "w")
output.puts(csv)
output.close


# Intro to Web,,,,
# ,Welcome,,,
# ,,Ruby Basics,,
# ,,,Strings,www.test.com
# ,,,Numbers,www.another.com
# ,,,Arrays,www.last.com