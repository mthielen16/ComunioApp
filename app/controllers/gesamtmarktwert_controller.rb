class GesamtmarktwertController < ApplicationController

  def index
    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
          backgroundColor:"rgba(255, 255, 255, 0.65)",
          plotShadow: true,
          plotBorderWidth: 1)
      f.lang(thousandsSep: ",")
      f.plotOptions(line: {marker: {enabled: false}})
      f.legend(enabled: false)

    end

    @date_array= Value.select(:date).distinct.pluck(:date)



    tw_value=[]
    aw_value=[]
    mf_value=[]
    st_value=[]
    ges_value=[]

    tw_list=Player.where(position: "Torhüter").pluck(:id)
    aw_list=Player.where(position: "Abwehr").pluck(:id)
    mf_list=Player.where(position: "Mittelfeld").pluck(:id)
    st_list=Player.where(position: "Stürmer").pluck(:id)
    ges_list=Player.pluck(:id)




    Value.where(cid: tw_list).group(:date).sum(:value).sort.to_h.each do |key,value|
      tw_value.push(value)
    end

    Value.where(cid: aw_list).group(:date).sum(:value).sort.to_h.each do |key,value|
      aw_value.push(value)
    end

    Value.where(cid: mf_list).group(:date).sum(:value).sort.to_h.each do |key,value|
      mf_value.push(value)
    end

    Value.where(cid: st_list).group(:date).sum(:value).sort.to_h.each do |key,value|
      st_value.push(value)
    end

    Value.where(cid: ges_list).group(:date).sum(:value).sort.to_h.each do |key,value|
      ges_value.push(value)
    end

    @tw_marktwert_gesamt = LazyHighCharts::HighChart.new('tw_marktwert_gesamt') do |f|
      f.chart({defaultSeriesType: "line"})
      f.series(name: "Marktwert", yAxis: 0, data: tw_value, color: "#666699")
      f.yAxis [{:title => {:text => "Marktwert in Millionen"},gridLineWidth: 0, minorGridLineWidth: 0,}]
      f.xAxis(categories: @date_array,minTickInterval: 7)
      f.legend(enabled: false)

    end

    @aw_marktwert_gesamt = LazyHighCharts::HighChart.new('aw_marktwert_gesamt') do |f|
      f.chart({defaultSeriesType: "line"})
      f.series(name: "Marktwert", yAxis: 0, data: aw_value, color: "#666699")
      f.yAxis [{:title => {:text => "Marktwert in Millionen"},gridLineWidth: 0, minorGridLineWidth: 0,}]
      f.xAxis(categories: @date_array,minTickInterval: 7)
      f.legend(enabled: false)

    end

    @mf_marktwert_gesamt = LazyHighCharts::HighChart.new('mf_marktwert_gesamt') do |f|
      f.chart({defaultSeriesType: "line"})
      f.series(name: "Marktwert", yAxis: 0, data: mf_value, color: "#666699")
      f.yAxis [{:title => {:text => "Marktwert in Millionen"},gridLineWidth: 0, minorGridLineWidth: 0,}]
      f.xAxis(categories: @date_array,minTickInterval: 7)
      f.legend(enabled: false)

    end

    @st_marktwert_gesamt = LazyHighCharts::HighChart.new('st_marktwert_gesamt') do |f|
      f.chart({defaultSeriesType: "line"})
      f.series(name: "Marktwert", yAxis: 0, data: st_value, color: "#666699")
      f.yAxis [{:title => {:text => "Marktwert in Millionen"},gridLineWidth: 0, minorGridLineWidth: 0,}]
      f.xAxis(categories: @date_array,minTickInterval: 7)
      f.legend(enabled: false)

    end

    @ges_marktwert_gesamt = LazyHighCharts::HighChart.new('ges_marktwert_gesamt') do |f|
      f.chart({defaultSeriesType: "line"})
      f.series(name: "Marktwert", yAxis: 0, data: ges_value, color: "#666699")
      f.yAxis [{:title => {:text => "Marktwert in Millionen"},gridLineWidth: 0, minorGridLineWidth: 0,}]
      f.xAxis(categories: @date_array,minTickInterval: 7)
      f.legend(enabled: false)
      f.plotOptions(line: {marker: {enabled: false}})


    end
  end
end
