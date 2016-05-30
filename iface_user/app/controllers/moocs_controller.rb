class MoocsController < ApplicationController
  before_action :set_mooc, only: [:show, :edit, :update, :destroy, :bdd_script_associations]

  # GET /moocs
  # GET /moocs.json
  def index
    @moocs = Mooc.all
  end

  # GET /moocs/1
  # GET /moocs/1.json
  def show
    @fichiers = @mooc.fichiers
    respond_to do |format|
      format.html { render :show, layout: false }
    end
  end

  # GET /moocs/new
  def new
    @mooc = Mooc.new
  end

  # GET /moocs/1/all
  def all
    @moocs = Mooc.all
    @id = params[:id].to_i
    render :index
  end

  # GET /moocs/1/edit
  def edit
    respond_to do |format|
      format.html { render :edit, layout: false }
    end
  end

  # POST /moocs
  # POST /moocs.json
  def create
    @mooc = Mooc.new(mooc_params)

    respond_to do |format|
      if @mooc.save
        format.html { redirect_to '/moocs/'+@mooc.id.to_s+'/all', notice: 'Mooc was successfully created.' }
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
        #format.html { redirect_to @mooc, notice: 'Mooc was successfully updated.' }
        format.html { redirect_to '/moocs/'+@mooc.id.to_s+'/all', layout: false, notice: 'Mooc édité' }
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
      format.html { redirect_to '/moocs', notice: 'Mooc supprimé' }
      format.json { head :no_content }
    end
  end

  # GET /moocs/1/bdd_script_associations
  # GET /moocs/1/bdd_script_associations.json

  def bdd_script_associations
    @bdd_script_associations = @mooc.bdd.bdd_script_associations
    respond_to do |format|
      format.html { redirect_to '/moocs' }
      format.json { render 'bdd_script_associations/index' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mooc
      @mooc = Mooc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mooc_params
      params.require(:mooc).permit(:auteur, :id_cours, :periode, :bdd_id, :nom)
    end
end
