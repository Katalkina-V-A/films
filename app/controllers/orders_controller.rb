class OrdersController < ApplicationController
  before_action :check_authentication
  before_action :check_edit, except: [:new, :create, :index, :show]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :check_edit_order, except: [:index, :new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_order
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.ordering.page(params[:page])
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if Order.edit_by?(@current_user)
      redirect_to orders_url
      return
    else
      if @current_user!=nil
        if @current_cart.line_items.empty?
          redirect_to books_url, notice: "Корзина пуста, совершите покупку."
          return
        end
      end
    end
    @order = Order.new(user: @current_user)
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.status = 0
    @order.user = @current_user
    @order.add_line_items_from_cart(@current_cart)

    if @order.save
      @current_cart.line_items.destroy
      redirect_to books_url, notice: 'Ваш заказ принят.'
    else
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
    if @order.destroy
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
      params.require(:order).permit(:name, :address, :email, :pay_type, :status, :delivery_type, :user_id)
    end
    def invalid_order
      redirect_to orders_url
    end
    def check_edit
      render_error unless Order.edit_by?(@current_user)
    end
    def check_edit_order
      render_error unless Order.edit_order_by?(@order.user_id, @current_user)
    end

end
