class DamsNote < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsNoteDatastream 
  has_attributes :value, :type, :displayLabel, :internalOnly, datastream: :damsMetadata, multiple: true
end
