class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[ show index ]
  before_action :set_product, only: %i[ show update destroy ]
  before_action :check_product_owner, only: %i[ update destroy ]

  # GET api/v1/products
  def index
    if current_user
      logger.debug "==>> current_user: #{current_user.email} <<=="
      logger.debug "==>> current_user role: #{current_user.role} <<=="
    else
      logger.debug "==>> NO USER <<=="
    end
    @products = Product.all

    render json: @products
  end

  # GET api/v1/products/1
  def show
    render json: @product
  end

  # POST api/v1/products
  def create

    if current_user
      logger.debug "==>> USER IS BUYER <<=="
      logger.debug "==>> current_user: #{current_user.email} <<=="
    else
      logger.debug "==>> NO USER <<=="
    end
    if !current_user || current_user.role == "buyer"
      render json: {
        status: { code: 401, message: 'Operation not authorized.' }#, status: :unauthorized
      }
      return
    end

    @product = Product.new(product_params)
    @product.seller = current_user

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT api/v1/products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE api/v1/products/1
  def destroy
    @product.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def check_product_owner
      if !current_user || current_user != @product.seller
        render json: {
          status: { code: 401, message: 'Operation not authorized. You must be the product owner to access this functionality.' }#, status: :unauthorized
        }
        return
      end
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:productName, :amountAvailable, :cost, :seller_id)
    end
end
