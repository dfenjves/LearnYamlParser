require 'pry'
yaml_file = File.open("test-yaml.yaml", "r")
yaml_content = yaml_file.read
yamarray = yaml_content.split("\n")
yamarray.delete_if do |item| 
  item.include?("uuid") || item.include?("contents") || item.match(/^\s{16}\S/)
end
yamarray.slice!(0..1)
newyamarray = yamarray.collect { |item| item.gsub("-   ","")  }


csv = "Topic Title,Unit Title,Lesson Title,Lesson URL\n"
newyamarray.each do |item|
  if item.match(/^\s{4}title/)
    csv += "#{item.strip.gsub("title: ","TOPIC: ")},,,\n"
  elsif item.match(/^\s{8}title/)
    csv += ",#{item.strip.gsub("title: ","UNIT: ")},,\n"
  elsif item.match(/^\s{12}title/)
    csv += ",,#{item.strip.gsub("title: ","LESSON: ")}," 
  elsif item.match(/source:/)
      csv += "#{item.strip.gsub("source: ","")}\n" 
  end
end

fname = "output.csv"
output = File.open(fname, "w")
output.puts(csv)
output.close


# Intro to Web,,,,
# ,Welcome,,,
# ,,Ruby Basics,,
# ,,,Strings,www.test.com
# ,,,Numbers,www.another.com
# ,,,Arrays,www.last.com