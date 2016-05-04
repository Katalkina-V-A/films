class LineItemsController < ApplicationController
  before_action :check_authentication
  before_action :check_edit, except: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_line_item
  # GET /line_items
  # GET /line_items.json
  def index
    if LineItem.edit_by?(@current_user)
      redirect_to orders_url
      return
    else
      if @current_user!=nil
        @line_items = LineItem.all
      end
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    if LineItem.edit_by?(@current_user)
      redirect_to orders_url
      return
    end
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
    redirect_to orders_url
    return
  end

  # POST /line_items
  # POST /line_items.json
  def create
    book = Book.find(params[:book_id])
    if @current_cart.present?
      @line_item = @current_cart.add_book(book.id)
    else
      @current_cart = Cart.new(user: @current_user)
      @line_item = @current_cart.add_book(book.id)
    end
    if @line_item.save
      redirect_to @line_item.cart, notice: 'Книга добавлена в корзину.'
      # redirect_to book, notice: 'Книга добавлена в корзину.'
    else
      render :new
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    if @line_item.update(line_item_params)
      redirect_to @line_item, notice: 'Товарная позиция изменена.'
    else
      render :edit
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    if @line_item.destroy
      redirect_to line_items_path, notice: 'Товарная позиция удалена.'
    else
      render_error('Удаление товарной позиции невозможно.')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:book_id)
    end
    def invalid_line_item
      redirect_to orders_url
    end
    def check_edit
      render_error unless LineItem.edit_by?(@current_user)
    end
end
