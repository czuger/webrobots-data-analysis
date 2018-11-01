require 'json'
require 'pp'
require 'active_record'
require 'time'
# require_relative 'process_file'
require 'open-uri'
require 'nokogiri'

n = Nokogiri.parse( open( 'https://webrobots.io/kickstarter-datasets/' ).read )
directory = '../data'

n.xpath("//li").each do |l|
  match = l.text.match( /(\d+)-(\d+)-(\d+) \[JSON\]/ )
  next unless match

  url = l.children[1].attribute('href').value

  puts "Downloading #{url}"
  f_name = directory + '/' + File.basename( url )

  `curl -o #{f_name} #{url}`
end