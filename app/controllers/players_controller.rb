class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players
  # GET /players.json
  def index
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


    if @value.count >= 7
      @seven_day_avg=Indicators::Data.new(@spieler_value.compact).calc(:type=>:sma, :params=>7).output
      3.times {@seven_day_avg=@seven_day_avg.drop(1).push(nil)}
    else
      @seven_day_avg = []
    end



    @spieltag_punkte =[]

    if @saisoninfo.sum(:einsätze) >= 1
      @spieltag_punkte.insert(@date_array.index(@saisoninfo.pluck(:date,:punkte)[0][0]),
                              @saisoninfo.pluck(:date,:punkte)[0][1])
    else
      @spieltag_punkte  =[]
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
      f.title(text: "Marktwert und Punkte")
      f.series(name: "Marktwert", yAxis: 0, data: @spieler_value, color: "#666699")
      f.series(name: "7-Tage Durchschnitt", yAxis: 0, data: @seven_day_avg, color: "#ff1313",enableMouseTracking: false)
      f.series(:type => 'column',name: "Punkte", yAxis: 1, data: @spieltag_punkte, color: "#2eb82e")
      f.yAxis [
          {:title => {:text => "Marktwert in Millionen", margin: 40},gridLineWidth: 0, minorGridLineWidth: 0, },
          {:title => {:text => "Punkte", margin: 40}, :opposite => true,gridLineWidth: 0, minorGridLineWidth: 0,}
              ]
      f.legend(enabled: true)
      f.xAxis(categories: @date_array,minTickInterval: 7)
    end



    @verein = @player.verein
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
