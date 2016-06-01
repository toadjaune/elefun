class BddsController < ApplicationController
  before_action :set_bdd, only: [:show, :edit, :update, :destroy]

  # GET /bdds
  # GET /bdds.json
  def index
    @bdds = Bdd.all
  end

  # GET /bdds/1
  # GET /bdds/1.json
  def show
  end

  # GET /bdds/new
  def new
    @bdd = Bdd.new
  end

  # GET /bdds/1/edit
  def edit
  end

  # POST /bdds
  # POST /bdds.json
  def create
    @bdd = Bdd.new(bdd_params)

    respond_to do |format|
      if @bdd.save
        format.html { redirect_to @bdd, notice: 'Bdd was successfully created.' }
        format.json { render :show, status: :created, location: @bdd }
      else
        format.html { render :new }
        format.json { render json: @bdd.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bdds/1
  # PATCH/PUT /bdds/1.json
  def update
    respond_to do |format|
      if @bdd.update(bdd_params)
        format.html { redirect_to @bdd, notice: 'Bdd was successfully updated.' }
        format.json { render :show, status: :ok, location: @bdd }
      else
        format.html { render :edit }
        format.json { render json: @bdd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bdds/1
  # DELETE /bdds/1.json
  def destroy
    @bdd.destroy
    respond_to do |format|
      format.html { redirect_to bdds_url, notice: 'Bdd was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bdd
      @bdd = Bdd.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bdd_params
      params.fetch(:bdd, {})
    end
end
