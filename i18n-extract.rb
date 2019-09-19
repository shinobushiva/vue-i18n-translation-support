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
relative_out_path = ARGV[1]

File.open(relative_out_path, "w") do |out_f|
  Dir["#{absoulte_path}/**/*"].each do |path|
    if FileTest.directory? path
      # nop
    elsif FileTest.file? path
      str = IO.read(path)
      match = str.match(/<i18n>(.*)<\/i18n>/m) rescue next
      next if match.nil?
      yaml = YAML.load(match[1])
      next unless !yaml.nil? && false != yaml
      result_map = {}
      langs = yaml.keys
      langs.each do |lang|
        if !yaml[lang].nil?
          collect(result_map, yaml[lang])
        end
      end
      
      next if result_map.keys.empty?
      header = ["file:#{path.sub(absoulte_path, '')}"]
      header.concat(langs)
      out_f.print(header.to_csv)
      result_map.keys.each do |key|
        ar = [key]
        ar.concat(result_map[key])
        out_f.print(ar.to_csv)
      end
      out_f.print("\n")
    else
      # raise 'neigher file nor directory'
    end
  end  
end