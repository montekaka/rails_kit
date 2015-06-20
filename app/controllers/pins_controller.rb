class PinsController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authentication_user!, except: [:index, :show]

  respond_to :html

  def index
    if current_user.nil?
    else
      @pins = current_user.pins
      respond_with(@pins)
    end
  end

  def show
    respond_with(@pin)
  end

  def new
    @pin = current_user.pins.build
    respond_with(@pin)
  end

  def edit
  end

  def create
    @pin = current_user.pins.build(pin_params)
    flash[:notice] = 'Pin was successfully created.' if @pin.save
    respond_with(@pin)
  end

  def update
    flash[:notice] = 'Pin was successfully updated.' if @pin.update(pin_params)
    respond_with(@pin)
  end

  def destroy
    @pin.destroy
    respond_with(@pin)
  end

  private
    def set_pin
      @pin = Pin.find(params[:id])
    end

    def correct_user
      @pin = current_user.pins.find_by(id: params[:id])
      redirect_to pins_path, notice: "Not authorized to edit this pin" if @pin.nil?
    end

    def pin_params
      params.require(:pin).permit(:description)
    end
end
