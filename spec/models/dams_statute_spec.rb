# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsStatute do
  let(:params) {
    { citation: "Family Education Rights and Privacy Act (FERPA)",
      jurisdiction: "us",
      note: "Limits disclosure of student information.",
      permission_node_attributes: [type: "display",beginDate: "2012-01-01",endDate: "2012-12-31"],
      restriction_node_attributes: [type: "display",beginDate: "1993-12-31",endDate: "2043-12-31"]
  }}
  subject do
    DamsStatute.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create a xml" do
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Statute rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <dams:permission>
      <dams:Permission>
        <dams:beginDate>2012-01-01</dams:beginDate>
        <dams:endDate>2012-12-31</dams:endDate>
        <dams:type>display</dams:type>        
      </dams:Permission>
    </dams:permission>        
    <dams:restriction>
      <dams:Restriction>
        <dams:type>display</dams:type>
        <dams:beginDate>1993-12-31</dams:beginDate>
        <dams:endDate>2043-12-31</dams:endDate>
      </dams:Restriction>
    </dams:restriction>
    <dams:statuteCitation>Family Education Rights and Privacy Act (FERPA)</dams:statuteCitation>
    <dams:statuteJurisdiction>us</dams:statuteJurisdiction>
    <dams:statuteNote>Limits disclosure of student information.</dams:statuteNote>    
  </dams:Statute>
</rdf:RDF>
END
    expect(subject.damsMetadata.content).to be_equivalent_to xml

  end
  
  it "should have restriction" do
    expect(subject.restrictionBeginDate).to eq(["1993-12-31"])
    expect(subject.restrictionEndDate).to eq(["2043-12-31"])
    expect(subject.restrictionType).to eq(["display"])
    
    expect(subject.restriction_node[0].beginDate).to eq(["1993-12-31"])
    expect(subject.restriction_node[0].endDate).to eq(["2043-12-31"])
    expect(subject.restriction_node[0].type).to eq(["display"])    
  end

  it "should be able to build a new restriction" do
    subject.restriction_node.build
    expect(subject.restriction_node.size).to eq(2)
  end    
end
