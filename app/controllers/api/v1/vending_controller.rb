class Api::V1::VendingController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_type

  # Receives { "coin_value": "X"}
  # X being integer multiple of 5 and under or equal 100
  def deposit
    unless is_integer?(params[:coin_value])
      render json: { status: 400, message: 'Coin value must be an integer' }, status: :unauthorized
      return
    end
    coin_ins = params[:coin_value].to_i
    if coin_ins.remainder(5) != 0 || coin_ins < 5 || coin_ins > 100
      render json: { status: 401, message: 'Coin value incorrect.' }, status: :unauthorized
      return
    end

    current_user["coin#{coin_ins}"] += 1

    if current_user.save
      render json: { code: 200, message: "Deposited #{coin_ins} coin with success.", data: current_user }
    else
      render json: { message: 'Error on deposit', errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end

  end

  # Receives { "productId": "X", "amount": Y }
  # returns { "totalSpent": "Z", "product": "productName", "change": { "5": "...", ..., "100": "..."} }
  def buy
    unless params[:productId]
      render json: { status: 400, message: 'Param missing' }, status: :unauthorized
      return
    end
    unless is_integer?(params[:amount])
      render json: { status: 400, message: 'Amount must be an integer' }, status: :unauthorized
      return
    end
    buy_amount = params[:amount].to_i

    product = Product.find(params[:productId])
    if product.nil?
      render json: { status: 404, message: "There's no product with the given Id." }, status: :unauthorized
      return
    end
    if product.amountAvailable < buy_amount
      render json: { status: 404, message: "The product quantity inserted is not available. Only #{product.amountAvailable} #{product.productName} available." }, status: :unauthorized
      return
    end

    # get total coins and sort them from higher to lower
    coins_attr = current_user.attributes.keys.each_with_object({}) { |coin, attrs| attrs[coin.delete_prefix("coin").to_i] = current_user[coin] if coin.include? "coin" }
    coins_attr = coins_attr.sort_by{ |val, qt| -val}.to_h

    # TODO: check user balance
    user_balance = coins_attr.sum {|k,v| k*v }

    totalCost = product.cost * buy_amount
    if totalCost > user_balance
      render json: { status: 403, message: "User balance is not enough to buy product." }, status: :unauthorized
      return
    end

    # pay the product
    coins_spent = pay(totalCost, coins_attr)

    # calculate change merging the two coins hashes and subtracting values
    change = coins_attr.merge(coins_spent) { | k, v1, v2| v1 - v2 }

    begin
      User.transaction do
        Product.transaction do
          current_user.update(coin5: 0, coin10: 0, coin20: 0, coin50: 0, coin100: 0)
          product.amountAvailable -= buy_amount
          product.save
        end
      end
    rescue Exception => e
      render :json => "Error saving changes"
      return
    end
    

    render(json: { totalSpent: totalCost, product: product.productName, change: change }) && 
    return
  end

  def reset
    if current_user.update(coin5: 0, coin10: 0, coin20: 0, coin50: 0, coin100: 0)
      render json: { status: 200, message: 'User deposit was reseted.' }, status: :ok
    else
      render json: { status: 401, message: current_user.errors }, status: :unprocessable_entity
    end
  end

  private

  def check_user_type
    unless current_user
      render json: { status: 401, message: 'User has no active session' }, status: :unauthorized
      return
    end

    if current_user.role != "buyer"
      render json: { status: 401, message: 'Operation not authorized.' }, status: :unauthorized
      return
    end
  end

  def is_integer?(string)
    true if Integer(string) rescue false
  end

  # pay the product(s) and returne coins spent
  def pay(cost, coins)
    coins.each_with_object(Hash.new(0)) do |coin, denoms_hash|
      coins_to_take = 0
      if coin[1] > 0
        if cost.divmod(coin[0]).first > coin[1]
          coins_to_take = coin[1]
        else
          coins_to_take = cost.divmod(coin[0]).first
        end
        denoms_hash[coin[0]] += coins_to_take
        cost -= coins_to_take * coin[0]
      end
    end
  end
end
