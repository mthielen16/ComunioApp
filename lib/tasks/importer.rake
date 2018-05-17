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


    keys = ["id","cid","position","tore","unknown","gelb","gelbrot","rot","punkte","note","min_ein","min_aus","einsatz","spieltag","heimaus","date"]




    matchday_number_array.each do |matchday|
      x= matchday
      nokogiri_storage = Nokogiri::HTML(open("https://www.comstats.de/matchdetails.php?mid=#{x}", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)).text
      json=JSON.parse(nokogiri_storage)


      json["h"].each do |row|
        Saisoninfo.create(Hash[keys.zip [Saisoninfo.maximum(:id)+1,row["i"],row["p"],row["t"],row["e"],row["g"],
                                         row["gr"],row["r"],row["pk"],row["no"],
                                         row["ew"],row["aw"],row["a"], spieltag,"h",(Date.today).to_s]])
      end

      json["a"].each do |row|
        Saisoninfo.create(Hash[keys.zip [Saisoninfo.maximum(:id)+1,row["i"],row["p"],row["t"],row["e"],row["g"],
                                         row["gr"],row["r"],row["pk"],row["no"],
                                         row["ew"],row["aw"],row["a"],spieltag,"a",(Date.today).to_s]])
      end
    end

    ##################### CREATER FROM SCRATCH!!!!!###########
    matchday_number_array=(3372..3524).to_a

    datearray=["19-08-2017".to_date.to_s,"26-08-2017".to_date.to_s,"09-09-2017".to_date.to_s,"16-09-2017".to_date.to_s,"20-09-2017".to_date.to_s,
               "23-09-2017".to_date.to_s,"30-09-2017".to_date.to_s,"14-10-2017".to_date.to_s,"21-10-2017".to_date.to_s,"28-10-2017".to_date.to_s,
               "04-11-2017".to_date.to_s,"18-11-2017".to_date.to_s,"25-11-2017".to_date.to_s,"02-12-2017".to_date.to_s,"09-12-2017".to_date.to_s,
               "13-12-2017".to_date.to_s,"16-12-2017".to_date.to_s]




    counter=  0
    spieltag=1

    matchday_number_array.each do |matchday|
      counter=counter+1

      x= matchday
      nokogiri_storage = Nokogiri::HTML(open("https://www.comstats.de/matchdetails.php?mid=#{x}", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)).text
      json=JSON.parse(nokogiri_storage)


      json["h"].each do |row|
        Saisoninfo.create(Hash[keys.zip [Saisoninfo.maximum(:id)+1,row["i"],row["p"],row["t"],row["e"],row["g"],
                                         row["gr"],row["r"],row["pk"],row["no"],
                                         row["ew"],row["aw"],row["a"], spieltag,"h", datearray[spieltag-1]]])
      end

      json["a"].each do |row|
        Saisoninfo.create(Hash[keys.zip [Saisoninfo.maximum(:id)+1,row["i"],row["p"],row["t"],row["e"],row["g"],
                                         row["gr"],row["r"],row["pk"],row["no"],
                                         row["ew"],row["aw"],row["a"],spieltag,"a",datearray[spieltag-1]]])
      end


      if counter == 9
        counter = 0
        spieltag=spieltag+1
      end
    end

    #############################




  end
end

