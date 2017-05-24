class OrdersController < ApplicationController

  def index_as_customer

    unless params[:status].in?(Order.statuses) or params[:status] == nil

      render json: { errors: [ { detail: "Invalid order status!" } ] }, status: 400
      return

    end

    render json: @company.list_orders_as_customer(params[:status]), status: 200

  end


  def index_as_provider

    unless params[:status].in?(Order.statuses) or params[:status] == "upcoming" or params[:status] == nil

      render json: {errors: [{detail:"Invalid order status!"}]}, status: 400
      return

    end

    render json: @company.list_orders_as_provider(params[:status]), status: 200

  end

  def create

    if params[:provider_id] == nil
      render json: {errors: [{detail:"Missing provider ID!"}]},
             status: 400
      return
    end
    provider = Company.find(params[:provider_id])
    customer = @company
    if provider == customer
      render json: {errors: [{detail:"You will never profit from ordering goods from your own company!\n(Invalid provider ID)"}]},
             status: 400
      return
    end
    order = Order.new(created_order_params)
    order.customer = customer
    order.provider = provider
    order.created = DateTime.now
    order.status = :created

    unless order.save
      render json: {errors: [{detail:"Some important info missing!"}], validation_errors: order.errors.full_messages},
             status: 400
      return
    end

    render json: order, status: 201

  end

  def show

    @order = Order.find(params[:id])
    if @order.is_associated(@company)
      render json: @order, status: 200
    else
      render json: {errors: [{detail:"You are not associated with this order!"}]}, status: 400
    end


  end

  def update

    status = params[:status]
    order = Order.find(params[:id])
    customer = order.customer
    provider = order.provider

    order = OrderManager.new(order).change_state_to('sent_out')

  end

private

  def created_order_params

    params.permit(:description, :deadline)

  end

  def updated_order_params

    params.permit(:status)

  end


end
