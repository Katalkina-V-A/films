class OrdersController < ApplicationController
  before_action :check_authentication
  before_action :check_edit, except: [:new, :create, :index]
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to books_url, notice: "Корзина пуста, совершите покупку."
      return
    end

    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.status = 0
    @order.add_line_items_from_cart(@cart)

    if @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      redirect_to books_url, notice: 'Ваш заказ принят.'
    else
      @cart = @current_cart
      render :new
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Заказ изменен.'
    else
      render :edit
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    if @cart.destroy
      redirect_to orders_url, notice: 'Заказ удален.'
    else
      render_error('Удаление заказа невозможно.', url: @order)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type, :status, :delivery_type)
    end

    def check_edit
      render_error unless Order.edit_by?(@current_user)
    end
end
