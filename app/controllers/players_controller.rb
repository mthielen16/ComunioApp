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

    values = @value.to_a
    @date_array= []
    @spieler_value = []
    values.each do |t|
      @spieler_value.push(t.value)
      @date_array.push(t.date)
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
        f.legend(enabled: false)
        f.chart({defaultSeriesType: "area"})
        f.plotOptions(area: {marker: {enabled: false}})

      end
    end






    @spieler_mw = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart({defaultSeriesType: "area"})
      f.series(name: "Marktwert von #{@Spielername} 17/18", yAxis: 0, data: @spieler_value, color: "#666699")
      f.yAxis [{title: {text: "Marktwert in Millionen", margin: 40} }]
      f.legend(enabled: false)
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
