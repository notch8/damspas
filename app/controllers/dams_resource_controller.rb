require 'net/http'
require 'json'

class DamsResourceController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  include CatalogHelper

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    refcon = referrer_controller request
    if params[:counter]
      # if there is a counter, update pager state & redirect to no-counter view
      session[:search][:counter] = params[:counter]
      session[:search_results] = request.referer if refcon == "catalog"
      redirect_to dams_object_path(params[:id])
      return
    else
      @blacklight_config = CatalogController.blacklight_config

      # if we were redirected from counter, setup next/prev
      controllers = ["catalog", "dams_collections", "dams_objects"]
      setup_next_and_previous_documents if controllers.include?(refcon)
      
      logger.info "setup_next_and_previous_documents start ..."
      logger.info "#{Time.now}"
      logger.debug "refcon: #{refcon} "
      
      if controllers.include?(refcon)
        if search_session[:counter] and current_search_session
          logger.debug "search_session[:counter] is: #{search_session[:counter]}"
          logger.debug "@search_context_response is: #{@search_context_response}"
          logger.debug "@previous_document is: #{@previous_document}"
        end
      end
      
    end

    # get metadata from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )

    @rdfxml = @document['rdfxml_ssi'] if !@document.nil?
    if @rdfxml == nil
      @rdfxml = "<rdf:RDF xmlns:dams='http://library.ucsd.edu/ontology/dams#'
          xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
          rdf:about='#{Rails.configuration.id_namespace}#{params[:id]}'>
  <dams:error>content missing</dams:error>
</rdf:RDF>"
    end

    url = check_type @document
    unless url.blank?
      redirect_to url
      return
    end

    # enforce access controls
    if can? :show, @document

      # find related resources
      collectionData = @document["collection_json_tesim"]
	  @collectionDocArray = Array.new
	  if !collectionData.nil? and collectionData.length > 0
	  	collectionData.each do |datum|
          collection = JSON.parse(datum)
		  collectionDoc = get_single_doc_via_search(1, {:q => "id:#{collection['id']}"} )
		  relatedResourceData = collectionDoc["related_resource_json_tesim"] unless collectionDoc.nil?
		  if !relatedResourceData.nil?
			relatedResourceData.each do |datum|
			  relatedResource = JSON.parse(datum)
			  if relatedResource['type'] != "hydra-afmodel"
			    @collectionDocArray << collectionDoc
				break
			  end			
			end
		  end
	    end
	  end

      find_linked_documents @document
	  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @document }
        format.rdf { render xml: @rdfxml }
        format.nt { rdf_nt }
        format.ttl { rdf_ttl }
      end
    elsif !@document.nil? && @document['discover_access_group_ssim'].include?("public")
      respond_to do |format|
        format.html { render :metadata }
        format.json { render json: @document }
        format.rdf { render xml: @rdfxml }
        format.nt { rdf_nt }
        format.ttl { rdf_ttl }
      end
    else
      authorize! :show, @document # 403 forbidden
    end
  end
  def find_linked_documents( document )
  end
  def redirect_other_types( document )
  end
  def dams42
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    params[:xsl] = "dams4.2.xsl"
    data = get_html_data params, nil
    render :xml => data, :content_type => 'application/rdf+xml'
  end 
  def data
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
  	controller_path = dams_collection_path params[:id]
    data = get_html_data params, controller_path
    render :text => data
  end 
  def rdf
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    params[:xsl] = "normalize.xsl"
    data = get_html_data params, nil
    render :xml => data, :content_type => 'application/rdf+xml'
  end
  def rdf_nt
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    data = get_data("nt")
    render :text => data, :content_type => 'application/n-triples'
  end
  def rdf_ttl
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    data = get_data("turtle")
    render :text => data, :content_type => 'text/turtle'
  end 
  def ezid
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :create, @document

    # mint doi
    begin
      json = dams_post "#{dams_api_path}/api/objects/#{params[:id]}/mint_doi?format=json"
      if json['statusCode'] == 200
        logger.info json['message']
        redirect_to dams_object_path(params[:id]), notice: "DOI minted, please allow a few minutes for Solr reindexing before the display is updated."
      else
        redirect_to dams_object_path(params[:id]), alert: "Minting DOI failed: #{json['message']}"
      end
    rescue Exception => e
      begin
        resp = JSON.parse( e.response.body )
        err = resp["message"]
      rescue
        err = "Error minting DOI: Unable to process server response"
      end
      redirect_to dams_object_path(params[:id]), alert: err
    end
  end

end
