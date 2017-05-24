class OrderManager
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def change_state_to(state)
    # if status == "in_process" or status == "sent_out"
    #   if @company == provider
    #     order.update(updated_order_params)
    #     render json: {message: "Current order status is '#{Order.find(params[:id]).status}'"}, status: 200
    #     return
    #   else
    #     render json: {errors: [{detail:"You must be the provider!"}]}, status: 400
    #     return
    #   end
    # elsif status == "accepted"
    #   if @company == customer
    #     order.update(updated_order_params)
    #     render json: {message: "Current order status is '#{Order.find(params[:id]).status}'"}, status: 200
    #     return
    #   else
    #     render json: {errors: [{detail:"You must be the customer!"}]}, status: 400
    #   end
    # else
    #   render json: {errors: [{detail:"Invalid status!"}]}, status: 400
    # end

    Order.find(1)

    Order.find_by(id: 1)
    Order.find_by_id(1)

    Order.find_by!(id: 1)
    Order.find_by_id!(1)

    begin
      Order.find(1)
    rescue ActiveRecord::NotFound => e
      render json: ...
    end


    
  end

end