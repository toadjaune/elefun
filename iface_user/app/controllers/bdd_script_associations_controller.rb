class BddScriptAssociationsController < ApplicationController
  before_action :set_bdd_script_association, only: [:show, :edit, :update, :destroy, :launch, :reset]

  # GET /bdd_script_associations
  # GET /bdd_script_associations.json
  def index
    @bdd_script_associations = BddScriptAssociation.all
  end

  # GET /bdd_script_associations/1
  # GET /bdd_script_associations/1.json
  def show
  end

  # GET /bdd_script_associations/new
  def new
    @bdd_script_association = BddScriptAssociation.new
  end

  # GET /bdd_script_associations/1/edit
  def edit
  end

  # POST /bdd_script_associations
  # POST /bdd_script_associations.json
  def create
    @bdd_script_association = BddScriptAssociation.new(bdd_script_association_params)

    respond_to do |format|
      if @bdd_script_association.save
        format.html { redirect_to @bdd_script_association, notice: 'BddScriptAssociation was successfully created.' }
        format.json { render :show, status: :created, location: @bdd_script_association }
      else
        format.html { render :new }
        format.json { render json: @bdd_script_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bdd_script_associations/1
  # PATCH/PUT /bdd_script_associations/1.json
  def update
    respond_to do |format|
      if @bdd_script_association.update(bdd_script_association_params)
        format.html { redirect_to @bdd_script_association, notice: 'BddScriptAssociation was successfully updated.' }
        format.json { render :show, status: :ok, location: @bdd_script_association }
      else
        format.html { render :edit }
        format.json { render json: @bdd_script_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bdd_script_associations/1
  # DELETE /bdd_script_associations/1.json
  def destroy
    @bdd_script_association.destroy
    respond_to do |format|
      format.html { redirect_to bdd_script_associations_url, notice: 'BddScriptAssociation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /bdd_script_associations/1/launch
  # GET /bdd_script_associations/1/launch.json
  def launch
    respond_to do |format|
      res = @bdd_script_association.launch
      if res.nil?
        format.html { redirect_to @bdd_script_association, notice: 'Script lancé avec succès.' }
        format.json { render :show, status: :ok, location: @bdd_script_association }
      else
        format.html { render :edit, notice: res }
        format.json { render json: @bdd_script_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /bdd_script_associations/1/reset
  # GET /bdd_script_associations/1/reset.json
  def reset
    respond_to do |format|
      if @bdd_script_association.reset_etat
        format.html { redirect_to @bdd_script_association, notice: 'Script réinitialisé avec succès.' }
        format.json { render :show, status: :ok, location: @bdd_script_association }
      else
        format.html { render :edit }
        format.json { render json: @bdd_script_association.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bdd_script_association
      @bdd_script_association = BddScriptAssociation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bdd_script_association_params
      # Tout est géré du côté du modèle. À aucun moment on a besoin de passer des paramètres
      params.require(:bdd_script_association).permit(:none)
    end
end
