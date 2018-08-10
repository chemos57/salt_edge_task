class LoginsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_login, only: [:show, :edit, :update, :destroy]

  # GET /logins
  # GET /logins.json
  def index
    @logins = Login.where(customer_id: current_user.customers.first.id)
  end

  # GET /logins/1
  # GET /logins/1.json
  def show
    api = SaltEdge.new("Wn97rBNJDxivIE3T3oLhDOr7qAhJytd63EGqDykHcl4", "ErynyWOwLeB9IQA6YPWLYOnnbPoW88DxRkks9OXWzkg", "/home/vasia/salt_edge_task/private.pem")
    cust_id = current_user.customers.first.cust_id
    r = api.simple_request("GET", "https://www.saltedge.com/api/v4/accounts?customer_id=" + cust_id)
    r["data"].each do |account|
      if @login.log_id == account["login_id"] 
        Account.where(acc_id: account["id"]).first_or_create do |acc|
          acc.a_name = account["name"]
          acc.nature = account["nature"]
          acc.balance = account["balance"]
          acc.currency_code = account["currency_code"]
          acc.login_id = @login.id
        end
      end
    end
    @accounts = Account.where(login_id: @login.id) 
  end

  # GET /logins/new
  def new
    @login = Login.new
  end

  # GET /logins/1/edit
  def edit
  end

  # POST /logins
  # POST /logins.json
  def create
    @login = Login.new(login_params)

    respond_to do |format|
      if @login.save
        format.html { redirect_to @login, notice: 'Login was successfully created.' }
        format.json { render :show, status: :created, location: @login }
      else
        format.html { render :new }
        format.json { render json: @login.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logins/1
  # PATCH/PUT /logins/1.json
  def update
    respond_to do |format|
      if @login.update(login_params)
        format.html { redirect_to @login, notice: 'Login was successfully updated.' }
        format.json { render :show, status: :ok, location: @login }
      else
        format.html { render :edit }
        format.json { render json: @login.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logins/1
  # DELETE /logins/1.json
  def destroy
    @login.destroy
    redirect_to "https://www.saltedge.com/clients/logins?statuses=" and return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_login
      @login = Login.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def login_params
      params.fetch(:login, {})
    end
end
