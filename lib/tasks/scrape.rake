# lib/tasks/scrape.rake

namespace :scrape do
  desc 'scrape data from comstats.
        Use: rake scrape:import in console'
  task :import => :environment do

    require 'openssl'
    require 'open-uri'
    require 'json'
    matchday = Nokogiri::HTML(open('https://www.comstats.de//', :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))


    entries = matchday.css('.sidebarElement')
    matchday_links = entries.css('a')
    matchday_links_compact = matchday_links.map {|element| element["href"]}.compact
    matchday_links_compact.pop                                                  #remove last row from table(summary row)


    #store matchday_numbers in array
    matchday_number_array=[]
    matchday_links_compact.each do |row|
      matchday_number_array.push(row[/y\/m(.*?)\//,1])
    end


    keys = ["id","cid","tore","unknown","gelb","gelbrot","rot","punkte","note","min_ein","min_aus","einsätze","heimaus","date"]


    matchday_number_array.each do |matchday|
      x= matchday
      nokogiri_storage = Nokogiri::HTML(open("https://www.comstats.de/matchdetails.php?mid=#{x}", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)).text
      json=JSON.parse(nokogiri_storage)


      json["h"].each do |row|
          Saisoninfo.create(Hash[keys.zip [Saisoninfo.maximum(:id)+1,row["i"],row["t"],row["e"],row["g"],
                                         row["gr"],row["r"],row["pk"],row["no"],
                                         row["ew"],row["aw"],row["a"],"h",(Date.today).to_s]])
      end

      json["a"].each do |row|
          Saisoninfo.create(Hash[keys.zip [Saisoninfo.maximum(:id)+1,row["i"],row["t"],row["e"],row["g"],
                                         row["gr"],row["r"],row["pk"],row["no"],
                                         row["ew"],row["aw"],row["a"],"a",(Date.today).to_s]])
      end
    end


  end
end

