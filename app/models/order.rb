class Order < ApplicationRecord

  enum status: [:created, :in_process, :sent_out, :accepted]

  belongs_to :customer, class_name: "Company"
  belongs_to :provider, class_name: "Company"
end
