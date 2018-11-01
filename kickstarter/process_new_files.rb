require 'json'
require 'pp'
require 'active_record'
require 'time'

class KickstarterDatas < ActiveRecord::Base
end

class ProcessFile

  def initialize
    @inserts = 0
    @updates = 0
  end

  def process_record( project )
    country = project['country']
    category = project['category']['slug']

    if project['usd_pledged']
      usd_pledged = project['usd_pledged']
    else
      usd_pledged = project['pledged'] * Currencies.value( project['currency'] )
    end

    backers_count = project['backers_count']

    state_changed_at = Time.at( project['state_changed_at'] )

    url = project['urls']['web']['project']
    project_id = project['id']
    raise unless project_id

    r = KickstarterDatas.where( record_id: project_id ).first

    if ( r && r.state_changed_at < state_changed_at || !r )

      unless r
        r = KickstarterDatas.new
        @inserts += 1
      else
        @updates += 1
      end

      r.country = country
      r.category= category
      r.year= state_changed_at.year
      r.month= state_changed_at.month
      r.backers_count= backers_count.to_i
      r.usd_pledged= usd_pledged.to_f
      r.avg_pledge= usd_pledged.to_f / backers_count.to_f
      r.url = url
      r.record_id = project_id
      r.state_changed_at = state_changed_at

      r.save!
    end
  end

  def do( file_path )
    wanted_categories = [ "games/tabletop games", "games/playing cards" ]

    File.open( file_path, 'r' ).each do |line|
      record = JSON.parse( line )['data']

      unless record['category']
        puts "Category not found for record"
        pp record
        next
      end

      next unless wanted_categories.include?( record['category']['slug'] )

      process_record( record )
    end

    puts "#{@inserts} rows inserted, #{@updates} rows updated."
  end

end

db_config = YAML.load_file( 'db/config.yml' )
ActiveRecord::Base.establish_connection(db_config['development'])

Dir.glob( 'data/*.json' ).each do |path|
  next unless File.file?( path )
  puts "Processing #{path}"
  ActiveRecord::Base.transaction do
    ProcessFile.new.do( path )
  end
end