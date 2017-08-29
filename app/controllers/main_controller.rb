class MainController < ApplicationController
  def index

  end


  def search
    @players   = Player.ransack(name_cont: params[:q]).result(distinct: true)
    respond_to do |format|
      format.html {}
      format.json {
        @players   = @players.limit(8)

      }


    end
  end
end
