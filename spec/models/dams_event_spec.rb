# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsEvent do
  subject do
    DamsEvent.new pid: "zzXXXXXXX1"
  end
  it "should create xml" do
    subject.type = "collection creation"
    subject.eventDate = "2012-11-06T09:26:34-0500"
    subject.outcome = "success"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:DAMSEvent rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">    
    <dams:eventDate>2012-11-06T09:26:34-0500</dams:eventDate>
    <dams:outcome>success</dams:outcome>
    <dams:type>collection creation</dams:type>
   </dams:DAMSEvent>
</rdf:RDF>
END
    expect(subject.damsMetadata.content).to be_equivalent_to xml

  end
end
