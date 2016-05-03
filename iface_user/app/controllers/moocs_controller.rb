class MoocsController < ApplicationController
  before_action :set_mooc, only: [:show, :edit, :update, :destroy]

  # GET /moocs
  # GET /moocs.json
  def index
    @moocs = Mooc.all
  end

  # GET /moocs/1
  # GET /moocs/1.json
  def show
  end

  # GET /moocs/new
  def new
    @mooc = Mooc.new
  end

  # GET /moocs/1/edit
  def edit
  end

  # POST /moocs
  # POST /moocs.json
  def create
    @mooc = Mooc.new(mooc_params)

    respond_to do |format|
      if @mooc.save
        format.html { redirect_to @mooc, notice: 'Mooc was successfully created.' }
        format.json { render :show, status: :created, location: @mooc }
      else
        format.html { render :new }
        format.json { render json: @mooc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moocs/1
  # PATCH/PUT /moocs/1.json
  def update
    respond_to do |format|
      if @mooc.update(mooc_params)
        format.html { redirect_to @mooc, notice: 'Mooc was successfully updated.' }
        format.json { render :show, status: :ok, location: @mooc }
      else
        format.html { render :edit }
        format.json { render json: @mooc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moocs/1
  # DELETE /moocs/1.json
  def destroy
    @mooc.destroy
    respond_to do |format|
      format.html { redirect_to moocs_url, notice: 'Mooc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mooc
      @mooc = Mooc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mooc_params
      params.require(:mooc).permit(:auteur, :id_cours, :periode, :bdd_id)
    end
end
