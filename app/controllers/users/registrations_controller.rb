class Users::RegistrationsController < Devise::RegistrationsController
  # POST resource
  def create
    super do
      api = SaltEdge.new("Wn97rBNJDxivIE3T3oLhDOr7qAhJytd63EGqDykHcl4", "ErynyWOwLeB9IQA6YPWLYOnnbPoW88DxRkks9OXWzkg", "/home/vasia/salt_edge_task/private.pem")
      r = api.request("GET", "https://www.saltedge.com/api/v4/customers/")
      customer = Customer.new
      customer.cust_id = r["data"]["id"].to_s
      customer.secret = r["data"]["secret"].to_s
      customer.identifier = r["data"]["identifier"].to_s
      customer.user_id = resource.id
      customer.save
    end
  end
end