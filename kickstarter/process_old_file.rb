require 'json'
require 'pp'
require 'active_record'
require 'time'

class KickstarterDatas < ActiveRecord::Base
end

class ProcessFile

  def self.do( file_path )
    wanted_categories = [ "games/tabletop games", "games/playing cards" ]

    inserts = 0

    File.open( file_path, 'r' ).each do |line|
      record = JSON.parse( line )['data']

      pp record
      # exit

      next unless wanted_categories.include?( record['category']['slug'] )

      summary = {}
      summary['goal'] = record['goal']
      summary['state'] = record['state']
      summary['country'] = record['country']
      summary['pledged'] = record['pledged']
      summary['country'] = record['country']
      summary['category'] = record['category']['slug']

      summary['deadline'] = Time.at( record['deadline'] )
      summary['created_at'] = Time.at( record['created_at'] )
      summary['launched_at'] = Time.at( record['launched_at'] )

      summary['usd_pledged'] = record['usd_pledged']
      summary['backers_count'] = record['backers_count']

      summary['state_changed_at'] = Time.at( record['state_changed_at'] )

      summary['currency'] = record['currency']
      summary['current_currency'] = record['current_currency']

      summary['converted_pledged_amount'] = record['converted_pledged_amount']

      url = record['urls']['web']['project']
      record_id = record['id']

      record = KickstarterDatas.where( record_id: record_id ).first_or_initialize do |r|
        r.country = summary['country']
        r.category= summary['category']
        r.year= summary['state_changed_at'].year
        r.month= summary['state_changed_at'].month
        r.backers_count= summary['backers_count'].to_i
        r.usd_pledged= summary['converted_pledged_amount'].to_f
        r.avg_pledge= summary['converted_pledged_amount'].to_f / summary['backers_count'].to_f
        r.url = url
        inserts += 1
      end
      record.save!

    end

    puts "#{inserts} row inserted."
  end

end

Dir.glob( '/mnt/shares/projet_geek/kick/old/*' ).each do |path|
  p path
end