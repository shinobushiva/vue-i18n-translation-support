require "bundler/setup"
require 'nokogiri'
require 'dotenv'

Dotenv.load

relative_path = ARGV[0]
absoulte_path = File.expand_path(ARGV[0], __FILE__)
p relative_path, absoulte_path

Dir["#{absoulte_path}/**/*"].each do |file|
  xml = Nokogiri::XML(file)
  p xml
  return
end