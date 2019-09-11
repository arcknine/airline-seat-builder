module Api::V1
  class SeatsController < BaseController
    before_action :verify_params, :only => [:index]

    def index
      @seater = SeatBuilder.new(@arg1, @arg2)
      if @seater.build
        render :json => @seater.allocated_seats
      else
        render :json => {error: true, messages: @seater.errors}, :status => :unprocessable_entity
      end
    end

    private

    def verify_params
      if params[:seats].blank? || params[:passengers].blank?
        # render :json => {error: true, messages: "Missing Parameters"}, :status => :unprocessable_entity
        render :json => params
        return
      end

      @arg1 = JSON.parse(params[:seats])
      @arg2 = params[:passengers]
    end
  end
end