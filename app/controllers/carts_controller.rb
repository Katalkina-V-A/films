class CartsController < ApplicationController
  before_action :check_authentication
  # skip_before_action :check_authentication, only: [:create, :update, :destroy]
  before_action :check_edit, except: [:destroy, :show]

  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  before_action :check_edit_cart
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    if @cart.line_items.blank?
      redirect_to books_url, notice: 'Корзина пуста.'
      return
    end
  end

  # GET /carts/new
  def new
    @cart = Cart.new(user: @current_user)
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)
    if @cart.save
      redirect_to @cart, notice: 'Корзина создана.'
    else
      render :new
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    if @cart.update(cart_params)
      redirect_to @cart, notice: 'Корзина изменена.'
    else
      render :edit
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy

    if @cart.destroy
      redirect_to books_url, notice: 'Корзина пуста.'
    else
      render_error('Удаление корзины невозможно.', url: @cart)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.require(:cart).permit(:user_id)
    end

    def check_edit
      render_error unless Cart.edit_by?(@current_user)
    end

    def invalid_cart
      redirect_to books_url, notice: 'Корзина пуста.'
    end

    def check_edit_cart
      render_error unless Cart.edit_cart_by?(@cart, @current_cart)
    end
end
