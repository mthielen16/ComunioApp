class MainController < ApplicationController
  def index
  end

  def search
    @movies    = Movie.ransack(name_cont: params[:q]).result(distinct: true)
    @players   = Player.ransack(name_cont: params[:q]).result(distinct: true)
    respond_to do |format|
      format.html {}
      format.json {
        @movies    = @movies.limit(5)
        @players   = @players.limit(5)
      }
    end
  end
end
