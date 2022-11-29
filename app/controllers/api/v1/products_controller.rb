class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[ show index ]
  before_action :set_product, only: %i[ show update destroy ]
  before_action :check_product_owner, only: %i[ update destroy ]

  # GET api/v1/products
  def index
    @products = Product.all

    if @products.blank?
      render json: { code: 200, products: @products, message: 'Products list is empty.' }
    else
      render json: @products
    end
  end

  # GET api/v1/products/1
  def show
    render json: @product
  end

  # POST api/v1/products
  def create
    if current_user.role == "buyer"
      render json: { code: 401, message: 'Only sellers can create products.' }
      return
    end

    @product = Product.new(product_params)
    @product.seller = current_user

    if @product.save
      render json: { code: 200, message: "Product created successfully.", product: @product }
    else
      render json: { code: 422, message: @product.errors.full_messages }
    end
  end

  # PATCH/PUT api/v1/products/1
  def update
    begin
      if @product.update(product_params)
        render json: { code: 200, message: "Product updated successfully.", product: @product }
      else
        render json: { code: 422, message: @product.errors.full_messages }
      end
    rescue Exception => e
      render :json => "Error saving changes"
      return
    end
  end

  # DELETE api/v1/products/1
  def destroy
    if @product.destroy
      render json: { code: 200, message: 'Product removed with success.' }
    else
      render json: { code: 401, message: 'Error removing product.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def check_product_owner
      if !current_user || current_user != @product.seller
        render json: { code: 401, message: 'Operation not authorized. You must be the product owner to access this functionality.' }
        return
      end
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:productName, :amountAvailable, :cost, :seller_id)
    end
end
