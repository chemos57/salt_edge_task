class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.where(user_id: current_user.id)
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    # while accesing a customer a user we'll be able to see the page with logins associated to 
    # that concrete customer
    api = SaltEdge.new(ENV["salt_edge_app_id"], ENV["salt_edge_secret"], "private.pem")
    r = api.simple_request("GET", "https://www.saltedge.com/api/v4/logins/")
    cust_id = current_user.customers.first.cust_id
    r["data"].each do |login|
      if cust_id == login["customer_id"]
        Login.where(log_id: login["id"]).first_or_create do |log|
          log.provider_name = login["provider_name"]
          log.customer_id = current_user.customers.first.id
        end
      end
    end 
    @logins = @customer.logins
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.fetch(:customer, {})
    end
end
