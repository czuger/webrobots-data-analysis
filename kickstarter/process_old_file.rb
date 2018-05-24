require 'json'
require 'pp'
require 'active_record'
require 'time'

class KickstarterDatas < ActiveRecord::Base
end

class ProcessFile

  @@currencies = Set.new

  def initialize
    @inserts = 0
  end

  def check_currencies( project )
    @@currencies << project['currency']
  end

  def process_record( project )
    country = project['country']
    category = project['category']['slug']

    usd_pledged = project['pledged']
    raise if project['currency'] != 'USD'

    backers_count = project['backers_count']

    state_changed_at = Time.at( project['state_changed_at'] )

    url = project['urls']['web']['project']
    project_id = project['id']

    record = KickstarterDatas.where( record_id: project_id ).first_or_initialize do |r|
      r.country = country
      r.category= category
      r.year= state_changed_at.year
      r.month= state_changed_at.month
      r.backers_count= backers_count.to_i
      r.usd_pledged= usd_pledged.to_f
      r.avg_pledge= usd_pledged.to_f / backers_count.to_f
      r.url = url
      @inserts += 1
    end
    record.save!
  end

  def do( file_path )
    wanted_categories = [ "games/tabletop games", "games/playing cards" ]

    inserts = 0

    data = JSON.parse( File.open( file_path, 'r' ).read )

    data.each do |record|
      record['projects'].each do |project|
        next unless wanted_categories.include?( project['category']['slug'] )
        check_currencies( project )
      end
    end

    # puts "#{inserts} row inserted."
  end

end

Dir.glob( '/mnt/shares/projet_geek/kick/old/*' ).each do |path|
  # KickstarterDatas.transaction do
    ProcessFile.new.do( path )
  # end
end

pp ProcessFile.currencies