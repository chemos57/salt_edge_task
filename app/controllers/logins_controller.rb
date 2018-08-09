class LoginsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_login, only: [:show, :edit, :update, :destroy]

  # GET /logins
  # GET /logins.json
  def index
    api = SaltEdge.new("Wn97rBNJDxivIE3T3oLhDOr7qAhJytd63EGqDykHcl4", "ErynyWOwLeB9IQA6YPWLYOnnbPoW88DxRkks9OXWzkg", "/home/vasia/salt_edge_task/private.pem")
    r = api.simple_request("GET", "https://www.saltedge.com/api/v4/logins/")
    cust_id = current_user.customers.first.cust_id
    r["data"].each do |login|
      if cust_id == login["customer_id"]
        Login.where(provider_name: login["provider_name"]).first_or_create do |log|
          log.log_id = login["id"]
        end
      end
    end 
    @logins = Login.all
  end

  # GET /logins/1
  # GET /logins/1.json
  def show
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
    respond_to do |format|
      format.html { redirect_to logins_url, notice: 'Login was successfully destroyed.' }
      format.json { head :no_content }
    end
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
