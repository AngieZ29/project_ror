class BanksController < ApplicationController
  def index
    @banks = Bank.all

    render json: @banks, status: :ok
  end

  def create
    @bank = Bank.new(val_params)

    if @bank.save
      render json: @bank, status: :ok
    else
      render json: { error: "Couldn't create bank'" }, status: :bad_request
    end
  end

  private

  def val_params
    params.require(:bank).permit(:name)
  end
end
