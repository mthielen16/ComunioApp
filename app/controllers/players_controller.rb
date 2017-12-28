class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players
  # GET /players.json
  def index


    @player = []
    @players = Player.all


  end

  # GET /players/1
  # GET /players/1.json
  def show
    @value    =  Value.where(cid: params[:id])
    @saisoninfo    =  Saisoninfo.where(cid: params[:id])




    @date_array= []
    @spieler_value = []
    @value.to_a.each do |t|
      @spieler_value.push(t.value)
      @date_array.push(t.date)
    end


    if @value.count >= 14
      @seven_day_avg=Indicators::Data.new(@spieler_value.compact).calc(:type=>:sma, :params=>14).output
      3.times {@seven_day_avg=@seven_day_avg.drop(1).push(nil)}
    else
      @seven_day_avg = []
    end



    @spieltag_punkte_plus =[]
    @spieltag_punkte_minus =[]



    if @saisoninfo.sum(:einsatz) >= 1
      @saisoninfo.distinct.pluck(:date).each do |date|
        if @saisoninfo.where(date: date).pluck(:punkte)[0] == nil
            next
        elsif @saisoninfo.where(date: date).pluck(:punkte)[0] >= 0
          @spieltag_punkte_plus.insert(@date_array.index(date) ,@saisoninfo.where(date: date).pluck(:punkte)[0])
        else
          @spieltag_punkte_minus.insert(@date_array.index(date) ,(@saisoninfo.where(date: date).pluck(:punkte)[0]*-1))
        end
      end
    else
      @spieltag_punkte_plus =[]
      @spieltag_punkte_minus =[]
    end

   if @spieltag_punkte_plus.empty? && @spieltag_punkte_minus.empty?
     xaxismax = 10
   else
    if (@spieltag_punkte_plus+@spieltag_punkte_minus).map(&:to_i).max <= 6
      xaxismax = 10
    else
      xaxismax = (@spieltag_punkte_plus+@spieltag_punkte_minus).map(&:to_i).max+5
    end
  end

    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
        f.global(useUTC: false)
        f.chart(
            backgroundColor:"rgba(255, 255, 255, 0.65)",
            plotShadow: true,
            plotBorderWidth: 1)
        f.lang(thousandsSep: ",")
        f.plotOptions(line: {marker: {enabled: false}})
      end

    @spieler_mw = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart({defaultSeriesType: "line"})
      f.series(name: "Marktwert", yAxis: 0, data: @spieler_value, color: "#666699")
      f.series(name: "14-Tage Durchschnitt", yAxis: 0, data: @seven_day_avg, color: "#D2691E",enableMouseTracking: false)
      f.series(:type => 'column',name: "Plus-Punkte", yAxis: 1, data: @spieltag_punkte_plus, color: "#2eb82e")
      f.series(:type => 'column',name: "Minus-Punkte", yAxis: 1, data: @spieltag_punkte_minus, color: "#ff1313")

      f.yAxis [
          {:title => {:text => "Marktwert in Millionen"},gridLineWidth: 0, minorGridLineWidth: 0, },
          {:title => {:text => "Punkte"}, :opposite => true,gridLineWidth: 0, minorGridLineWidth: 0,
           allowDecimals: false,max: xaxismax}
              ]
      f.legend(enabled: true)
      f.xAxis(categories: @date_array,minTickInterval: 7)
    end



    @verein = @player.verein







    @tw_value=[]
    torwartlist=Player.where(position: "Torhüter").pluck(:id)

    Value.where(cid: torwartlist).group(:date).sum(:value).each do |key,value|
      @tw_value.push(value)
    end

    @tw_marktwert_gesamt = LazyHighCharts::HighChart.new('tw_marktwert_gesamt') do |f|
      f.chart({defaultSeriesType: "area"})
      f.series(name: "Marktwert", yAxis: 0, data: @tw_value, color: "#666699")

      f.yAxis [{:title => {:text => "Marktwert in Millionen"},gridLineWidth: 0, minorGridLineWidth: 0, }
              ]
      f.legend(enabled: true)
      f.xAxis(categories: @date_array,minTickInterval: 7)
    end


  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
      @verein = @player.verein+'.png'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.fetch(:player, {})
    end
end
