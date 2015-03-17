class DamsPreferredCitationNoteDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|    
    map.value(:in=> RDF)
    map.displayLabel(:in=>DAMS)
    map.type(:in=>DAMS)
    map.internalOnly(:in=>DAMS)
  end

  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.PreferredCitationNote]) if new?
    super
  end
  def to_solr (solr_doc = {})           
    Solrizer.insert_field(solr_doc, 'preferredCitationNote_value', value)
	Solrizer.insert_field(solr_doc, 'preferredCitationNote_displayLabel', displayLabel)
	Solrizer.insert_field(solr_doc, 'preferredCitationNote_type', type) 
	Solrizer.insert_field(solr_doc, 'preferredCitationNote_internalOnly', internalOnly) 
	 # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      if solr_doc[f].kind_of?(Array)
        solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
      elsif solr_doc[f] != nil
        solr_doc[f] = solr_doc[f].gsub('+00:00','Z')
      end
    }		
    return solr_doc
  end    
end
