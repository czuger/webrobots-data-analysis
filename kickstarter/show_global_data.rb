require 'pp'
require 'active_record'
require 'action_view'
require 'action_controller'

def ntoh( number )
  ActionController::Base.helpers.number_to_currency( number,  delimiter: " " )
end

# games/tabletop games
# games/playing cards
#
request = "SELECT year, count( * ), sum( usd_pledged )/count( * ), sum( usd_pledged ), sum( backers_count ), avg( avg_pledge )
FROM kickstarter_datas
GROUP BY year;"

db_config = YAML.load_file( 'db/config.yml' )
ActiveRecord::Base.establish_connection(db_config['development'])

puts "%s\t%10s\t%18s\t%20s\t%12s\t%18s" % ['Year', 'Projects', 'Per project avg', 'Total', 'Backers', 'Per backer avg']

ActiveRecord::Base.connection.execute( request ).each do |data|
  datas = 0.upto(5).map{ |n| data[n] }

  # datas[2] = ntoh( data[2])
  # datas[3] = ntoh( data[3])
  # datas[5] = ntoh( data[5])

  puts "%d\t%10d\t%18s\t%20s\t%12d\t%18s" % datas
  # puts "#{data[0]} #{data[1]} #{ActionController::Base.helpers.number_to_currency(data[2])} #{data[3]} #{data[4]} #{data[5]}"
end


