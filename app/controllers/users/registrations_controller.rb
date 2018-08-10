class Users::RegistrationsController < Devise::RegistrationsController
  # POST resource
  def create
    super do
      # extends custom devise user registration behaviour
      api = SaltEdge.new(ENV["salt_edge_app_id"], ENV["salt_edge_secret"], "private.pem")
      r = api.request("GET", "https://www.saltedge.com/api/v4/customers/")
      customer = Customer.new
      customer.cust_id = r["data"]["id"].to_s
      customer.secret = r["data"]["secret"].to_s
      customer.identifier = r["data"]["identifier"].to_s
      customer.user_id = resource.id
      customer.save
      # redirect to choose fakebank provider for login
      # then redirect to pre-set page url in saltedge client's dashboard
      t = api.request("POST", "https://www.saltedge.com/api/v4/tokens/create", {cust_id: "" + r["data"]["id"].to_s + ""})
      link = t["data"]["connect_url"]
      puts t
      puts link
      redirect_to link and return
      # after setting your provider you'll be redirected to pre-set page url in saltedge client's dashboard
      # will have to re-login again to your app
    end
  end
end