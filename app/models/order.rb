class Order < ApplicationRecord

  enum status: [:created, :in_process, :sent_out, :accepted]

  belongs_to :customer, class_name: "Company"
  belongs_to :provider, class_name: "Company"

  validates :provider, presence: true
  validates :description, presence: true
  validates :deadline, presence: true

  def is_associated (company)
    if company.id == customer_id or company.id == provider_id
      return true
    else
      return false
    end
  end

end
