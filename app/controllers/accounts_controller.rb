class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    api = SaltEdge.new("Wn97rBNJDxivIE3T3oLhDOr7qAhJytd63EGqDykHcl4", "ErynyWOwLeB9IQA6YPWLYOnnbPoW88DxRkks9OXWzkg", "/home/vasia/salt_edge_task/private.pem")
    acc = Account.find(params[:id])
    login_id = acc.login.log_id
    account_id = acc.acc_id
    r = api.simple_request("GET", "https://www.saltedge.com/api/v4/transactions?login_id=" + login_id)
    r["data"].each do |account|
      if account_id == account["account_id"]
        Transaction.where(tr_id: account["id"]).first_or_create do |tr|
          tr.mode = account["mode"]
          tr.status = account["status"]
          tr.amount = account["amount"]
          tr.description = account["description"]
          tr.account_id = acc.id
        end
      end
    end
    @transactions = Transaction.where(account_id: acc.id)
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.fetch(:account, {})
    end
end
