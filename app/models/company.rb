class Company < ApplicationRecord
  has_many :orders_as_customer, class_name: "Order", foreign_key: "customer_id"
  has_many :orders_as_provider, class_name: "Order", foreign_key: "provider_id"


  def list_orders_as_customer(status)
    if status == nil
      return orders_as_customer
    end
    return orders_as_customer.where(:status => status)
  end


  def list_orders_as_provider(status)
    if status == nil
      return orders_as_provider
    elsif status == "upcoming"
      return orders_as_provider.where("deadline < ? AND deadline >= ?", Date.today.next_week, Date.today.beginning_of_week)
    else
      return orders_as_provider.where(:status => status)
    end
  end


end
