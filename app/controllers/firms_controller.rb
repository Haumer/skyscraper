class FirmsController < ApplicationController
  def index
    @firms = Firm.all
  end
end
