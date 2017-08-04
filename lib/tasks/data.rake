namespace :data do
  desc "import data from json to database Importer.
        Use: rake data:import in console"
  task :import => :environment do
    twhash=JSON.parse HTTParty.get('http://com-analytics.de/ajax/topplayers/keeper?_=1496939417796').response.body
    awhash=JSON.parse HTTParty.get('http://com-analytics.de/ajax/topplayers/defender?_=1496939417797').response.body
    mfhash=JSON.parse HTTParty.get('http://com-analytics.de/ajax/topplayers/midfielder?_=1497019780489').response.body
    sthash=JSON.parse HTTParty.get('http://com-analytics.de/ajax/topplayers/striker?_=1497019780490').response.body
    variable_array =[twhash,awhash,mfhash,sthash]

    puts ""
    puts "########################################################################"
    puts "################------------JSON PARSE-----------######################"

    playerkeys =["id","name","position","verein","punkte","pps"]
    keys = ["id","cid","date","value"]



    #fasst die jsons zu import_array zusammen: id name position, verein, mw, punkte, pps,
    #fügt neue spieler newcid array hinzu
    #fügt neue spieler der Tabelle players hinzu
    #fügt Marktwerte der Tabelle values hinzu
    variable_array.each do |hashes|
       hashes["data"].each do |nested_arrays|
         nested_arrays.flatten.values_at(0,1,2,3,4,5,6)
            if !Player.exists?(id: nested_arrays.flatten[0])
              Player.create(Hash[playerkeys.zip nested_arrays.flatten.values_at(0,1,2,3,5,6)])
              Value.create(Hash[keys.zip [Value.maximum(:id)+1,nested_arrays.flatten[0],
                                        (Date.today).to_s,nested_arrays.flatten[4]]])
            else
              Value.create(Hash[keys.zip [Value.maximum(:id)+1,nested_arrays.flatten[0],
                                        (Date.today).to_s,nested_arrays.flatten[4]]])

       end
      end
    end
  puts ""
  puts "########################################################################"
  puts "################------------IMPORT DONE-----------######################"
  puts "########################################################################"
  puts ""





  end
end
