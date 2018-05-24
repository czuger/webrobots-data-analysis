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
request = "SELECT *
FROM kickstarter_datas
WHERE year = 2016
AND category = 'games/tabletop games'
ORDER BY usd_pledged DESC LIMIT 10;"

db_config = YAML.load_file( 'db/config.yml' )
ActiveRecord::Base.establish_connection(db_config['development'])

ActiveRecord::Base.connection.execute( request ).each do |data|
  p data
end


