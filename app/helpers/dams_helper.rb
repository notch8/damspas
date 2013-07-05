module DamsHelper


## RelatedResource#############################################################
def relatedResourceType
    relatedResource[0] ? relatedResource[0].type: []
  end
  def relatedResourceType=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      relatedResource.build if relatedResource[0] == nil
      relatedResource[0].type = val
    end
  end

def relatedResourceDescription
    relatedResource[0] ? relatedResource[0].description: []
  end
  def relatedResourceDescription=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      relatedResource.build if relatedResource[0] == nil
      relatedResource[0].description = val
    end
  end

def relatedResourceUri
    relatedResource[0] ? relatedResource[0].uri: []
  end
  def relatedResourceUri=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      relatedResource.build if relatedResource[0] == nil
      relatedResource[0].uri = val
    end
  end


 ## scopeContentNote ######################################################################
 
  def scopeContentNoteType
    scopeContentNote[0] ? scopeContentNote[0].type : []
  end
  def scopeContentNoteType=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      scopeContentNote.build if scopeContentNote[0] == nil
      scopeContentNote[0].type = val
    end
  end   
  
 def scopeContentNoteDisplayLabel
    scopeContentNote[0] ? scopeContentNote[0].displayLabel : []
  end
  def scopeContentNoteDisplayLabel=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      scopeContentNote.build if scopeContentNote[0] == nil
      scopeContentNote[0].displayLabel = val
    end
  end   

  def scopeContentNoteValue
    scopeContentNote[0] ? scopeContentNote[0].value : []
  end
  def scopeContentNoteValue=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      scopeContentNote.build if scopeContentNote[0] == nil
      scopeContentNote[0].value = val
    end
  end   

 
 ## Note ######################################################################
 def noteValue
    note[0] ? note[0].value : []
  end
  def noteValue=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      note.build if note[0] == nil
      note[0].value = val
    end
  end

  def noteType
    note[0] ? note[0].type : []
  end
  def noteType=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      note.build if note[0] == nil
      note[0].type = val
    end
  end

  def noteDisplayLabel
    note[0] ? note[0].displayLabel : []
  end
  def noteDisplayLabel=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      note.build if note[0] == nil
      note[0].displayLabel = val
    end
  end

  ## Title ######################################################################
  def subtitle
    title[0] ? title[0].subtitle : []
  end
  def subtitle=(val)
    if val.class == Array
    	val = val.first
    end
    if(!val.nil? && val.length > 0)
    	title.build if title[0] == nil
    	title[0].subtitle = val
    end
  end

  def titleValue
    title.first != nil ? title.first.value : nil
  end
  def titleValue=(s)
    title.build if title.first.nil?
    title.first.value = s
    title.first.name = title.first.label
  end
  def subtitle
    title.first != nil ? title.first.subtitle : nil
  end
  def subtitle=(s)
    title.build if title.first.nil?
    title.first.subtitle = s
    title.first.name = title.first.label
  end
  def titlePartName
    title.first != nil ? title.first.partName : nil
  end
  def titlePartName=(s)
    title.build if title.first.nil?
    title.first.partName = s
    title.first.name = title.first.label
  end
  def titlePartNumber
    title.first != nil ? title.first.partNumber : nil
  end
  def titlePartNumber=(s)
    title.build if title.first.nil?
    title.first.partNumber = s
    title.first.name = title.first.label
  end  

   def titleNonSort
    title.first != nil ? title.first.nonSort : nil
  end
  def titleNonSort=(s)
    title.build if title.first.nil?
    title.first.nonSort = s
    title.first.name = title.first.label
  end  

  ## Subject ######################################################################
  def subjectValue
    subject[0] ? subject[0].name : []
  end
  def subjectValue=(val)
    i = 0
	val.each do |v| 
		if(!v.nil? && v.length > 0)
		    subject.build if subject[i] == nil
		    subject[i].name = v
		end
		i+=1
	end
  end

  def subjectType
    @subType
  end
  def subjectType=(val)
    #@subType = val
    @subType = Array.new
    i = 0
	val.each do |v| 
	    if(!v.nil? && v.length > 0)
	    	@subType << v 	
	    end
		i+=1
	end
  end
   
  def subjectTypeValue
    #topic[0] ? topic[0].name : []
    if(!@subType.nil? && (@subType.include? 'Topic'))
	    topic[0] ? topic[0].name : []
	elsif(!@subType.nil? && (@subType.include? 'BuiltWorkPlace'))
	    builtWorkPlace[0] ? builtWorkPlace[0].name : []		
	elsif(!@subType.nil? && (@subType.include? 'CulturalContext'))
	    culturalContext[0] ? culturalContext[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'Function'))
	    function[0] ? function[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'GenreForm'))
	    genreForm[0] ? genreForm[0].name : []		
	elsif(!@subType.nil? && (@subType.include? 'Geographic'))
	    geographic[0] ? geographic[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'Iconography'))
	    iconography[0] ? iconography[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'ScientificName'))
	    scientificName[0] ? scientificName[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'StylePeriod'))
	    stylePeriod[0] ? stylePeriod[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'Technique'))
	    technique[0] ? technique[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'Temporal'))
	    temporal[0] ? temporal[0].name : []	    	    	    	        	    	    	    
    end
  end
  def subjectTypeValue=(val)
    i = 0
    topicIndex = 0
    workplaceIndex = 0
    culturalContextIndex = 0
    functionIndex = 0
    genreFormIndex = 0
    geographicIndex = 0
    iconographyIndex = 0
    scientificNameIndex = 0
    stylePeriodIndex = 0
    techniqueIndex = 0
    temporalIndex = 0
	val.each do |v| 
		if(!v.nil? && v.length > 0)
			if(!@subType[i].nil? && (@subType[i].include? 'Topic'))
			    topic.build if topic[topicIndex] == nil
			    topic[topicIndex].name = v
			    topicIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'BuiltWorkPlace'))
			    builtWorkPlace.build if builtWorkPlace[workplaceIndex] == nil
			    builtWorkPlace[workplaceIndex].name = v	
			    workplaceIndex+=1	
			elsif(!@subType[i].nil? && (@subType[i].include? 'CulturalContext'))
			    culturalContext.build if culturalContext[culturalContextIndex] == nil
			    culturalContext[culturalContextIndex].name = v
			    culturalContextIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'Function'))
			    function.build if function[functionIndex] == nil
			    function[functionIndex].name = v	
			    functionIndex+=1	
			elsif(!@subType[i].nil? && (@subType[i].include? 'GenreForm'))
			    genreForm.build if genreForm[genreFormIndex] == nil
			    genreForm[genreFormIndex].name = v
			    genreFormIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'Geographic'))
			    geographic.build if geographic[geographicIndex] == nil
			    geographic[geographicIndex].name = v	
			    geographicIndex+=1	
			elsif(!@subType[i].nil? && (@subType[i].include? 'Iconography'))
			    iconography.build if iconography[iconographyIndex] == nil
			    iconography[iconographyIndex].name = v
			    iconographyIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'ScientificName'))
			    scientificName.build if scientificName[scientificNameIndex] == nil
			    scientificName[scientificNameIndex].name = v	
			    scientificNameIndex+=1	
			elsif(!@subType[i].nil? && (@subType[i].include? 'Technique'))
			    technique.build if technique[techniqueIndex] == nil
			    technique[techniqueIndex].name = v
			    techniqueIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'Temporal'))
			    temporal.build if temporal[temporalIndex] == nil
			    temporal[temporalIndex].name = v	
			    temporalIndex+=1				    			    			    			    	    
		    end
		end
		i+=1
	end
  end
    
  def subjectURI=(val)
    i = 0
    @array_subject = Array.new
	val.each do |v| 
	    if(!v.nil? && v.length > 0)
	    	@subURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{v}")  
	    	@array_subject << @subURI  	
	    end
		i+=1
	end
  end

  def subjectURI
    if @subURI != nil
      @subURI
    else
      subURI.first
    end
  end  
  
  ## Language ######################################################################  
  def languageURI
    if @langURI != nil
      @langURI
    else
      langURI.first
    end
  end 
  def languageURI=(val)
    if val.class == Array
    	val = val.first
    end
	 if(!val.nil? && val.first.length > 0)
	    @langURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")   	
	  end
  end
 
  ## Unit ######################################################################
  def unitURI=(val)
    if val.class == Array
    	val = val.first
    end
    if(!val.nil? && val.length > 0)
    	@unitURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
    end
  end
  def unitURI
    if @unitURI != nil
      @unitURI
    else
      unitURI.first
    end
  end     

  ## Collection ######################################################################
  def assembledCollectionURI=(val)
    if val.class == Array
    	val = val.first
    end
    if(!val.nil? && val.length > 0)
    	@assembledCollURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
    end
  end
  def assembledCollectionURI
    if @assembledCollURI != nil
      @assembledCollURI
    else
      asembledCollectionURI.first
    end
  end 

  def provenanceCollectionURI=(val)
    if val.class == Array
    	val = val.first
    end
    if(!val.nil? && val.length > 0)
    	@provenanceCollURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
    end
  end
  def provenanceCollectionURI
    if @provenanceCollURI != nil
      @provenanceCollURI
    else
      provenanceCollectionURI.first
    end
  end     

  def damsObjectURI=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      @damsObjURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
    end
  end
  def damsObjectURI
    if @damsObjURI != nil
      @damsObjURI
    else
      damsObjectURI.first
    end
  end     
  
 def provenanceCollectionPartURI=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      @provenanceCollPartURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
    end
  end
  def provenanceCollectionPartURI
    if @provenanceCollPartURI != nil
      @provenanceCollPartURI
    else
      provenanceCollectionPartURI.first
    end
  end     

  ## Date ######################################################################
  def beginDate
    date[0] ? date[0].beginDate : []
  end
  def beginDate=(val)
    if val.class == Array
      val = val.first
    end
    if(!val.nil? && val.length > 0)
      date.build if date[0] == nil
      date[0].beginDate = val
    end
  end


  def endDate
    date[0] ? date[0].endDate : []
  end
  def endDate=(val)
    if val.class == Array
    	val = val.first
    end  
    if(!val.nil? && val.length > 0)
    	date.build if date[0] == nil
    	date[0].endDate = val
    end
  end
  def dateValue
    date[0] ? date[0].value : []
  end
  def dateValue=(val)
    if val.class == Array
    	val = val.first
    end  
    if(!val.nil? && val.length > 0)
    	date.build if date[0] == nil
    	date[0].value = val
    end
  end

  
  
  def permissionBeginDate
    permission_node[0] ? permission_node[0].beginDate : []
  end
  def permissionBeginDate=(val)
    if permission_node[0] == nil
      permission_node.build
    end
    permission_node[0].beginDate = val
  end
  def permissionEndDate
    permission_node[0] ? permission_node[0].endDate : []
  end
  def permissionEndDate=(val)
    if permission_node[0] == nil
      permission_node.build
    end
    permission_node[0].endDate = val
  end
  def permissionType
    permission_node[0] ? permission_node[0].type : []
  end
  def permissionType=(val)
    if permission_node[0] == nil
      permission_node.build
    end
    permission_node[0].type = val
  end

  def restrictionBeginDate
    restriction_node[0] ? restriction_node[0].beginDate : []
  end
  def restrictionBeginDate=(val)
    if restriction_node[0] == nil
      restriction_node.build
    end
    restriction_node[0].beginDate = val
  end
  def restrictionEndDate
    restriction_node[0] ? restriction_node[0].endDate : []
  end
  def restrictionEndDate=(val)
    if restriction_node[0] == nil
      restriction_node.build
    end
    restriction_node[0].endDate = val
  end
  def restrictionType
    restriction_node[0] ? restriction_node[0].type : []
  end
  def restrictionType=(val)
    if restriction_node[0] == nil
      restriction_node.build
    end
    restriction_node[0].type = val
  end  

  ## ElementListValue for MADS classes ######################################################################
  def getElementValue(type)
    elem = find_element type
    if elem != nil
      elem.elementValue.first
    else
      []
    end
  end
  
  def setElementValue(type,val)
    if val.class == Array
        val = val.first
    end

    if elementList[0] == nil
      elementList.build
    end

    existing_elem = find_element type

    #need to use eList.size to know where to insert/update the value
    if(existing_elem != nil )
      # set value of existing element
      existing_elem.elementValue = val
    else
      # create a new element of the correct type
      if type.include? "TopicElement"
        elem = MadsDatastream::List::TopicElement.new(elementList.first.graph)
      elsif type.include? "BuiltWorkPlaceElement"
        elem = MadsDatastream::List::BuiltWorkPlaceElement.new(elementList.first.graph)
	  elsif type.include? "BuiltWorkPlaceElement"
        elem = MadsDatastream::List::BuiltWorkPlaceElement.new(elementList.first.graph)
	  elsif type.include? "CulturalContextElement"
        elem = MadsDatastream::List::CulturalContextElement.new(elementList.first.graph)
      elsif type.include? "FunctionElement"
        elem = MadsDatastream::List::FunctionElement.new(elementList.first.graph)
	  elsif type.include? "GenreFormElement"
        elem = MadsDatastream::List::GenreFormElement.new(elementList.first.graph)              
      elsif type.include? "GeographicElement"
        elem = MadsDatastream::List::GeographicElement.new(elementList.first.graph)
	  elsif type.include? "IconographyElement"
        elem = MadsDatastream::List::IconographyElement.new(elementList.first.graph)
	  elsif type.include? "ScientificNameElement"
        elem = MadsDatastream::List::ScientificNameElement.new(elementList.first.graph)
      elsif type.include? "TechniqueElement"
        elem = MadsDatastream::List::TechniqueElement.new(elementList.first.graph)
	  elsif type.include? "TemporalElement"
        elem = MadsDatastream::List::TemporalElement.new(elementList.first.graph)     
	  elsif type.include? "OccupationElement"
        elem = MadsDatastream::List::OccupationElement.new(elementList.first.graph)                                          
      end
      elem.elementValue = val

      # add new element to the end of the list
      if elementList.first.nil?
        elementList.first.value = elem
      else
        elementList.first[elementList.first.size] = elem
      end
    end 
  end
  
  def find_element( type )
    chain = elementList.first
    elem = nil
    while  elem == nil && chain != nil do
      if chain.first.class.name.include? type
        elem = chain.first
      else
        chain = chain.tail
      end
    end
    elem
  end 
end
