require "bundler/setup"
require 'yaml'
require "csv"

def collect(result_map, target, current_key = '')
  if target.is_a?(Hash)
    target.keys rescue return
    target.keys.each do |key|
      collect(result_map, target[key], "#{current_key}/#{key}")
    end
  else
    result_map[current_key] = [] if result_map[current_key].nil?
    result_map[current_key].push(target)
    return
  end
end

relative_path = ARGV[0]
absoulte_path = File.expand_path("../#{ARGV[0]}", __FILE__)
relative_input_path = ARGV[1]

array = []
langs = []
CSV.foreach(relative_input_path) do |line|
  next if line[0].nil?
  if langs.empty? && line[0].start_with?('file:')
    line[1..-1].each do |lang|
      langs.push(lang) unless lang.nil?
    end
  end
  array.push(line)
end
array.push(['file:dummy']) # add dummy for end detection
file = nil
obj = {}
array.each do |row|
  if (row[0].start_with?('file:'))
    if !file.nil?
      path = "#{absoulte_path}#{file}"
      buffer = File.open(path, "r") { |f| f.read() }
      # if you do not want to keep original file comment out next line
      # File.open("#{path}.bak" , "w") { |f| f.write(buffer) }
      buffer.gsub!(/<i18n>.*<\/i18n>/m, 
        <<~STR
        <i18n>
        #{obj.to_yaml.sub('---', '').strip}
        </i18n>
        STR
      )
      File.open(path, "w") { |f| f.write(buffer.strip + "\n") }
    end
    file = row[0].sub('file:', '')
    obj = {}
    langs.each do |lang| obj[lang] = {} end
  else
    keys = row[0].split('/')[1..-1]
    langs.each_with_index do |lang, lang_i|
      target = obj[lang]
      keys.each_with_index do |key, i|
        target[key] = {} if target[key].nil?
        if i == keys.length-1
          target[key] = row[1 + lang_i]
        else
          target = target[key]
        end
      end
    end
  end
end