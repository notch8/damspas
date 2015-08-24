class DamsComponentDatastream < DamsResourceDatastream
  include Dams::ModelHelper
  map_predicates do |map|
    map.title(:in => DAMS, :class_name => 'MadsTitle')
    map.date(:in => DAMS, :to=>'date', :class_name => 'DamsDate')
    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
    map.language(:in=>DAMS, :class_name => 'MadsLanguageInternal')

    # notes
    map.note(:in => DAMS, :to=>'note', :class_name => 'DamsNoteInternal')
    map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'DamsCustodialResponsibilityNoteInternal')
    map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'DamsPreferredCitationNoteInternal')
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'DamsScopeContentNoteInternal')

    # subjects
    map.subject(:in => DAMS, :to=> 'subject', :class_name => 'Subject')
    map.complexSubject(:in => DAMS)
    map.builtWorkPlace(:in => DAMS)
    map.culturalContext(:in => DAMS)
    map.function(:in => DAMS)
    map.genreForm(:in => DAMS)
    map.geographic(:in => DAMS)
    map.iconography(:in => DAMS)
    map.occupation(:in => DAMS)
    map.commonName(:in => DAMS)
    map.scientificName(:in => DAMS)
    map.stylePeriod(:in => DAMS)
    map.technique(:in => DAMS)
    map.temporal(:in => DAMS)
    map.topic(:in => DAMS)

    # subject names
    map.name(:in => DAMS, :class_name => 'MadsNameInternal')
    map.conferenceName(:in => DAMS, :class_name => 'MadsConferenceNameInternal')
    map.corporateName(:in => DAMS, :class_name => 'MadsCorporateNameInternal')
    map.familyName(:in => DAMS, :class_name => 'MadsFamilyNameInternal')
    map.personalName(:in => DAMS, :class_name => 'MadsPersonalNameInternal')

    # related resources and events
    map.relatedResource(:in => DAMS, :class_name => 'DamsRelatedResourceInternal')
    map.event(:in=>DAMS, :class_name => 'DamsEventInternal')

    # unit and collections
    map.unit(:in => DAMS, :to=>'unit', :class_name => 'DamsUnitInternal')
    map.collection(:in => DAMS)
    map.assembledCollection(:in => DAMS, :class_name => 'DamsAssembledCollectionInternal')
    map.provenanceCollection(:in => DAMS, :class_name => 'DamsProvenanceCollectionInternal')
    map.provenanceCollectionPart(:in => DAMS, :class_name => 'DamsProvenanceCollectionPartInternal')

    # components and files
    map.component(:in => DAMS, :to=>'hasComponent', :class_name => 'DamsComponentInternal')
    #map.subcomponent(:in=>DAMS, :to=>'hasComponent', :class => 'DamsComponent')
    map.file(:in => DAMS, :to=>'hasFile', :class_name => 'DamsFile')

    # rights
    map.copyright(:in=>DAMS,:class_name => 'DamsCopyrightInternal')
    map.license(:in=>DAMS,:class_name => 'DamsLicenseInternal')
	map.otherRights(:in=>DAMS,:class_name => 'DamsOtherRightInternal')
    map.statute(:in=>DAMS,:class_name => 'DamsStatuteInternal')
    map.rightsHolder(:in=>DAMS,:class_name => 'DamsRightsHolderInternal')

    # resource type and cartographics
    map.typeOfResource(:in => DAMS, :to => 'typeOfResource')
    map.cartographics(:in => DAMS, :class_name => 'Cartographics')
 end
 
  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }


  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Component]) if new?
    super
  end

   
  def id
    cid = rdf_subject.to_s
    cid = cid.match('\w+$').to_s
    cid.to_i
  end

  def insertSourceCapture( solr_doc, cid, fid, sourceCapture )
    prefix = (cid != nil) ? "component_#{cid}_file_#{fid}" : "file_#{fid}"
    if sourceCapture.class == DamsSourceCapture
      Solrizer.insert_field(solr_doc, "#{prefix}_source_capture", sourceCapture.pid)
      Solrizer.insert_field(solr_doc, "#{prefix}_capture_source", sourceCapture.captureSource)
      Solrizer.insert_field(solr_doc, "#{prefix}_image_producer", sourceCapture.imageProducer)
      Solrizer.insert_field(solr_doc, "#{prefix}_scanner_manufacturer", sourceCapture.scannerManufacturer)
      Solrizer.insert_field(solr_doc, "#{prefix}_scanner_model_name", sourceCapture.scannerModelName)
      Solrizer.insert_field(solr_doc, "#{prefix}_scanning_software", sourceCapture.scanningSoftware)
      Solrizer.insert_field(solr_doc, "#{prefix}_scanning_software_version", sourceCapture.scanningSoftwareVersion)
      Solrizer.insert_field(solr_doc, "#{prefix}_source_type", sourceCapture.sourceType)
    end
  end
          
  def to_solr (solr_doc = {})
 	storedInt = Solrizer::Descriptor.new(:integer, :indexed, :stored)
    singleString = Solrizer::Descriptor.new(:string, :indexed, :stored)
    storedIntMulti = Solrizer::Descriptor.new(:integer, :indexed, :stored, :multivalued)
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    
    # component metadata
    @parents = Hash.new
    @children = Array.new
    if component != nil && component.count > 0
      Solrizer.insert_field(solr_doc, "component_count", component.count, storedInt )
    end
    component.map.sort{ |a,b| a.id <=> b.id }.each { |component|
      cid = component.id
      @parents[cid] = Array.new

      # child components
      component.subcomponent.map.sort{ |c,d| c.id <=> d.id }.each { |subcomponent|
        subid = /\/(\w*)$/.match(subcomponent.to_s)
        gid = subid[1].to_i
        @children << gid
        Solrizer.insert_field(solr_doc, "component_#{cid}_children", gid, storedIntMulti)
        @parents[cid] << gid
      }

      # titles
      n = 0
      component.title.map do |title|
        n += 1
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_title", title.value)
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_subtitle", title.subtitle)
      end

      Solrizer.insert_field(solr_doc, "component_#{cid}_resource_type", format_name(component.typeOfResource.first))

      n = 0
      component.date.map do |date|
        n += 1
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_date", date.value)
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_beginDate", date.beginDate)
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_endDate", date.endDate)
      end

      insertNoteFields solr_doc, "component_#{cid}_note",component.note, DamsNote
      insertNoteFields solr_doc, "component_#{cid}_custodialResponsibilityNote",component.custodialResponsibilityNote, damsCustodialResponsibilityNote
      insertNoteFields solr_doc, "component_#{cid}_preferredCitationNote",component.preferredCitationNote, DamsPreferredCitationNote
      insertNoteFields solr_doc, "component_#{cid}_scopeContentNote",component.scopeContentNote, DamsScopeContentNote

      insertComplexSubjectFields solr_doc, "component_#{cid}_complexSubject", load_complexSubjects(component.complexSubject)
      insertFields solr_doc, "component_#{cid}_builtWorkPlace", load_builtWorkPlaces(component.builtWorkPlace)
      insertFields solr_doc, "component_#{cid}_culturalContext", load_culturalContexts(component.culturalContext)
      insertFields solr_doc, "component_#{cid}_function", load_functions(component.function)
      insertFields solr_doc, "component_#{cid}_genreForm", load_genreForms(component.genreForm)
      insertFields solr_doc, "component_#{cid}_geographic", load_geographics(component.geographic)
      insertFields solr_doc, "component_#{cid}_iconography", load_iconographies(component.iconography)
      insertFields solr_doc, "component_#{cid}_occupation", load_occupations(component.occupation)
      insertFields solr_doc, "component_#{cid}_commonName", load_commonNames(component.commonName)
      insertFields solr_doc, "component_#{cid}_scientificName", load_scientificNames(component.scientificName)
      insertFields solr_doc, "component_#{cid}_stylePeriod", load_stylePeriods(component.stylePeriod)
      insertFields solr_doc, "component_#{cid}_technique", load_techniques(component.technique)
      insertFields solr_doc, "component_#{cid}_temporal", load_temporals(component.temporal)
      insertFields solr_doc, "component_#{cid}_topic", load_topics(component.topic)

      insertFields solr_doc, "component_#{cid}_name", load_names(component.name)
      insertFields solr_doc, "component_#{cid}_conferenceName", load_conferenceNames(component.conferenceName)
      insertFields solr_doc, "component_#{cid}_corporateName", load_corporateNames(component.corporateName)
      insertFields solr_doc, "component_#{cid}_familyName", load_familyNames(component.familyName)
      insertFields solr_doc, "component_#{cid}_personalName", load_personalNames(component.personalName)

      component.file.map.sort{ |a,b| a.order <=> b.order }.each { |file|
        fid = file.id
        Solrizer.insert_field(solr_doc, "component_#{cid}_files", fid)
        Solrizer.insert_field(solr_doc, "file_#{cid}_#{fid}_filestore", file.filestore)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_quality", file.quality)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_size", file.size, singleString)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_sourcePath", file.sourcePath)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_sourceFileName", file.sourceFileName)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_use", file.use)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_label", file.value)

        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_dateCreated", file.dateCreated)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_formatName", file.formatName)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_mimeType", file.mimeType)

        insertSourceCapture solr_doc, cid, fid, load_sourceCapture(file.sourceCapture)
      }
    }

    # build component hierarchy map
    @cmap = Hash.new
    @parents.keys.sort{|x,y| x.to_i <=> y.to_i}.each { |p|
      # only process top-level objects
      if not @children.include?(p)
        # p is a top-level component, find direct children
        @cmap[p] = find_children(p)
      end
    }
    Solrizer.insert_field(solr_doc, "component_map", @cmap.to_json)

    file.map.sort{ |a,b| a.order <=> b.order }.each { |file|
      fid = file.id
      Solrizer.insert_field(solr_doc, "files", fid)
      Solrizer.insert_field(solr_doc, "file_#{fid}_filestore", file.filestore)
      Solrizer.insert_field(solr_doc, "file_#{fid}_quality", file.quality)
      Solrizer.insert_field(solr_doc, "file_#{fid}_size", file.size, singleString)
      Solrizer.insert_field(solr_doc, "file_#{fid}_sourcePath", file.sourcePath)
      Solrizer.insert_field(solr_doc, "file_#{fid}_sourceFileName", file.sourceFileName)
      Solrizer.insert_field(solr_doc, "file_#{fid}_use", file.use)
      Solrizer.insert_field(solr_doc, "file_#{fid}_label", file.value)

      Solrizer.insert_field(solr_doc, "file_#{fid}_dateCreated", file.dateCreated)
      Solrizer.insert_field(solr_doc, "file_#{fid}_formatName", file.formatName)
      Solrizer.insert_field(solr_doc, "file_#{fid}_mimeType", file.mimeType)

      insertSourceCapture solr_doc, nil, fid, load_sourceCapture(file.sourceCapture)
    }

    Solrizer.insert_field(solr_doc, "rdfxml", self.content, singleString)

	super
  end  
  
end

