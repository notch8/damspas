class DAMS < RDF::Vocabulary("http://library.ucsd.edu/ontology/dams#")
  property :title
  property :type
  property :date
  property :Date
  property :beginDate
  property :endDate
  property :encoding
  property :language
  property :typeOfResource
  property :relatedResource
  property :RelatedResource
  property :description
  property :uri
  property :relationship
  property :Relationship
  property :role
  property :name
  property :conferenceName
  property :commonName
  property :commonNameElement
  property :CommonNameElement
  property :corporateName
  property :familyName
  property :personalName
  property :assembledCollection
  property :AssembledCollection
  property :provenanceCollection
  property :ProvenanceCollection
  property :provenanceCollectionPart
  property :ProvenanceCollectionPart
  property :Object
  property :collection
  property :preferredCitationNote
  property :PreferredCitationNote
  property :custodialResponsibilityNote
  property :CustodialResponsibilityNote
  property :scopeContentNote
  property :ScopeContentNote
  property :displayLabel
  property :subject
  property :complexSubject
  property :builtWorkPlace
  property :builtWorkPlaceElement
  property :commonName
  property :commonNameElement
  property :CommonName
  property :CommonNameElement
  property :culturalContext
  property :CulturalContext
  property :culturalContextElement
  property :CulturalContextElement
  property :function
  property :Function
  property :functionElement
  property :FunctionElement
  property :genreForm
  property :geographic
  property :iconography
  property :Iconography
  property :iconographyElement
  property :IconographyElement
  property :lithology
  property :Lithology
  property :lithologyElement
  property :LithologyElement
  property :series
  property :Series
  property :seriesElement
  property :SeriesElement
  property :cruise
  property :Cruise
  property :cruiseElement
  property :CruiseElement
  property :anatomy
  property :Anatomy
  property :anatomyElement
  property :AnatomyElement
  property :occupation
  property :scientificName
  property :ScientificName
  property :scientificNameElement
  property :ScientificNameElement
  property :stylePeriod
  property :StylePeriod
  property :stylePeriodElement
  property :StylePeriodElement
  property :technique
  property :Technique
  property :TechniqueElement
  property :temporal
  property :topic
  property :rightsHolder
  property :rightsHolderName
  property :rightsHolderPersonal
  property :rightsHolderCorporate
  property :rightsHolderFamily
  property :rightsHolderConference    
  property :Unit
  property :unit
  property :unitName
  property :unitGroup
  property :unitURI
  property :unitDescription
  property :copyright
  property :Copyright
  property :copyrightStatus
  property :copyrightJurisdiction
  property :copyrightPurposeNote
  property :copyrightNote
  property :statute
  property :Statute
  property :statuteCitation
  property :statuteJurisdiction
  property :statuteNote
  property :permission
  property :restriction
  property :Permission
  property :Restriction
  property :license
  property :License
  property :licenseNote
  property :licenseURI
  property :otherRights
  property :OtherRights
  property :otherRightsBasis
  property :otherRightsNote
  property :otherRightsURI
  property :code
  property :component
  property :Component
  property :filestore
  property :File
  property :sourcePath
  property :sourceFileName
  property :formatName
  property :formatVersion
  property :mimeType
  property :use
  property :size
  property :crc32checksum
  property :md5checksum
  property :sha1checksum
  property :sha256checksum
  property :sha512checksum
  property :dateCreated
  property :objectCategory
  property :compositionLevel
  property :preservationLevel
  property :quality
  property :duration
  property :hasComponent
  property :hasFile
  property :note
  property :Note
  property :hasAssembledCollection
  property :hasProvenanceCollection
  property :provenanceCollection_node
  property :hasObject
  property :hasPart
  property :part_node
  property :relatedCollection
  property :scannerManufacturer
  property :sourceType
  property :scannerModelName
  property :imageProducer
  property :scanningSoftwareVersion
  property :scanningSoftware
  property :captureSource
  property :SourceCapture
  property :sourceCapture
  property :BuiltWorkPlace
  property :BuiltWorkPlaceElement
  property :cartographics
  property :Cartographics
  property :point
  property :line
  property :polygon
  property :projection
  property :referenceSystem
  property :scale
  property :eventDate
  property :detail
  property :outcome
  property :DAMSEvent
  property :event
  property :visibility  
  property :internalOnly
  property :object
  property :order
  property :visibility

  # superclasses/superproperties that would not be used in implementation, but
  # included for completeness
  property :Collection
  property :DAMSResource
  property :DAMSThing
  property :Rights
  property :RightsAction
  property :checksum
  property :hasCollection
  property :rightsAction
end
