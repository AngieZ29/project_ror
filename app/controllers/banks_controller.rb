class BanksController < ApplicationController
  def index
    @banks = Bank.all

    render json: @banks, status: :ok
  end
end
