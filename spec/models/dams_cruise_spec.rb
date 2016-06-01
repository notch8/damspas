# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCruise do
  let(:params) {
    {name: "Test Cruise", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        cruiseElement_attributes: [{ elementValue: "Test Cruise" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd9386739x", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    DamsCruise.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create rdf/xml" do
    xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <dams:Cruise rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Test Cruise</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <dams:CruiseElement>
        <mads:elementValue>Test Cruise</mads:elementValue>
      </dams:CruiseElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>    
  </dams:Cruise>
</rdf:RDF>
END
    expect(subject.damsMetadata.content).to be_equivalent_to xml
  end

  it "should have cruiseElement" do
    expect(subject.cruiseElement.first.elementValue).to eq('Test Cruise')
  end

  it "should be able to build a new cruiseElement" do
    subject.elementList.cruiseElement.build
  end
end