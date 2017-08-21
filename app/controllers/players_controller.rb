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


    values = @value.to_a
    @date_array= []
    @spieler_value = []
    values.each do |t|
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



    @spielerdata = []
    Player.find_by(id: params[:id]).attributes.each do |key, value|
      @spielerdata.push value

      @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
        f.global(useUTC: false)
        f.chart(
            backgroundColor: {
                linearGradient: [0, 0, 500, 500],
                stops: [
                    [0, "rgb(255, 255, 255)"],
                    [1, "rgb(240, 240, 255)"]
                ]
            },

            plotBackgroundColor: "rgba(255, 255, 255, .9)",
            plotShadow: true,
            plotBorderWidth: 1)
        f.lang(thousandsSep: ",")
        f.chart({defaultSeriesType: "area"})
        f.plotOptions(line: {marker: {enabled: false}})

      end
    end






    @spieler_mw = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart({defaultSeriesType: "line"})
      f.title(text: "Marktwert und Punkte")
      f.series(name: "Marktwert", yAxis: 0, data: @spieler_value, color: "#666699")
      f.series(name: "7-Tage Durchschnitt", yAxis: 0, data: @seven_day_avg, color: "#ff1313",enableMouseTracking: false)
      f.series(:type => 'column',name: "Punkte", yAxis: 1, data: @spieltag_punkte, color: "#2eb82e")
      f.yAxis [
          {title: {date: "Marktwert in Millionen", margin: 40} },
          {:title => {:text => "Punkte"}, :opposite => true}
              ]
      f.legend(enabled: true)
      f.xAxis(categories: @date_array)


    end




  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.fetch(:player, {})
    end
end
