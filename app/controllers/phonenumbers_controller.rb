class PhonenumbersController < ApplicationController
  def index_npa
    @npa = PhoneNumber.npa
  end

  def index_nxx
    @npa  = params[:npa]
    @nxx  = PhoneNumber.nxx
  end

  def index_line
    @npa   = params[:npa]
    @nxx   = params[:nxx]
    @lines = Kaminari.paginate_array(PhoneNumber.line).page(params[:page]).per 1000
  end

  def show
    @phone_number = PhoneNumber.new(params[:id])
    bad_number_redirect unless @phone_number.valid?
  end

  def search
    @phone_number = PhoneNumber.new(params['number'])
    if @phone_number.valid?
      redirect_to phonenumber_path @phone_number
    else
      bad_number_redirect
    end
  end

  def caller_id
    authorize!(:read_number_premium, PhoneNumber)
    caller_id = PhoneNumber.new(params[:phonenumber_id]).caller_id
    respond_to do |format|
      format.json { render json: caller_id }
    end
  end

  private

  def bad_number_redirect
    flash[:error] = 'Not a valid number'
    redirect_to :root
  end
end
