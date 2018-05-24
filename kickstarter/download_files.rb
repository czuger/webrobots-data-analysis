require 'json'
require 'pp'
require 'active_record'
require 'time'
require_relative 'process_file'
require 'open-uri'
require 'nokogiri'

n = Nokogiri.parse( open( 'https://webrobots.io/kickstarter-datasets/' ).read )
directory = '/mnt/shares/projet_geek/kick/'

n.xpath("//li").each do |l|
  match = l.text.match( /(\d+)-(\d+)-(\d+) \[JSON\]/ )
  next unless match

  # p match

  year = match[1].to_i
  month = match[2].to_i
  day = match[3].to_i

  dump_date = Time.new( year, month, day )
  # puts dump_date

  # next if dump_date > Time.new( 2015, 9 )

  # p l
  url = l.children[1].attribute('href').value
  # p l.text

  puts "Downloading #{url}"
  f_name = directory + File.basename( url )
  # p f_name

  open( "#{f_name}", 'wb') do |file|
    file << open(url).read
  end

  puts "Unzipping #{f_name}"
  `gunzip -f #{f_name}`
end