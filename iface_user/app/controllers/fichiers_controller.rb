class FichiersController < ApplicationController
  # GET /fichiers
  # GET /fichiers.json
  def index
    @fichiers = Fichier.all

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @fichiers.map{|fichier| fichier.to_jq_upload } }
      format.json { render :json => { :files => @fichiers.map{|upload| upload.to_jq_upload }} }
    end
  end

  # GET /fichiers/1
  # GET /fichiers/1.json
  def show
    @fichier = Fichier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fichier }
    end
  end

  # GET /fichiers/new
  # GET /fichiers/new.json
  def new
    @fichier = Fichier.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fichier }
    end
  end

  # GET /fichiers/1/edit
  def edit
    @fichier = Fichier.find(params[:id])
  end

  # POST /fichiers
  # POST /fichiers.json
  def create
    @fichier = Fichier.new(fichier_params)

    respond_to do |format|
      if @fichier.save
#        format.html { redirect_to @fichier, notice: 'Fichier was successfully created.' }
#        format.json { render :show, status: :created, location: @fichier }
        format.html {
          render :json => [@fichier.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@fichier.to_jq_upload]}, status: :created, location: @fichier }
      else
#        format.html { render :new }
        format.html { render action: "new" }
        format.json { render json: @fichier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fichiers/1
  # PATCH/PUT /fichiers/1.json
  def update
    @fichier = Fichier.find(params[:id])

    respond_to do |format|
      if @fichier.update(fichier_params)
        format.html { redirect_to @fichier, notice: 'Fichier was successfully updated.' }
#        format.json { render :show, status: :ok, location: @fichier }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fichier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fichiers/1
  # DELETE /fichiers/1.json
  def destroy
    @fichier = Fichier.find(params[:id])
    @rendu = @fichier.genre
    @mooc = Mooc.find(@fichier.mooc_id)
    @fichier.destroy

    respond_to do |format|
      format.html { render partial: "fichiersmoocs" }
#      format.html { redirect_to fichiers_url, notice: 'Fichier was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def fichier_params
    params.require(:fichier).permit(:nom, :mooc, :fichier, :genre, :mooc_id)
  end
end
