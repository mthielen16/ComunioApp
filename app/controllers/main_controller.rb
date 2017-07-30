class MainController < ApplicationController
  def index
  end

  def search
    @movies    = Movie.ransack(name_cont: params[:q]).result(distinct: true)

    respond_to do |format|
      format.html {}
      format.json {
      }
    end
  end
end
