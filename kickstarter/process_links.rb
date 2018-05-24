require 'json'
require 'pp'
require 'active_record'
require 'time'
require_relative 'process_file'
require 'open-uri'
require 'nokogiri'

db_config = YAML.load_file( 'db/config.yml' )
ActiveRecord::Base.establish_connection(db_config['development'])

n = Nokogiri.parse( open( 'https://webrobots.io/kickstarter-datasets/' ).read )

n.xpath("//li").each do |l|
  match = l.text.match( /(\d+)-(\d+)-(\d+) \[JSON\]/ )
  next unless match

  # p match

  year = match[1].to_i
  month = match[2].to_i

  next if year < 2015
  next if year == 2015 && month < 10

  # p l
  url = l.children[1].attribute('href').value
  # p l.text

  puts "Downloading #{url}"
  open('/tmp/kick.json.gz', 'wb') do |file|
    file << open(url).read
  end

  puts "Unzipping #{url}"
  `gunzip -f /tmp/kick.json.gz`

  puts 'Inserting data'
  ProcessFile.do( '/tmp/kick.json' )
end