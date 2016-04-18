# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsOccupation do
  let(:params) {
    {name: "Pharmacist", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        occupationElement_attributes: [{ elementValue: "Pharmacist" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd9386739x", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    MadsOccupation.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create rdf/xml" do
    xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:Occupation rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Pharmacist</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
    <mads:elementList rdf:parseType="Collection">
      <mads:OccupationElement>
        <mads:elementValue>Pharmacist</mads:elementValue>
      </mads:OccupationElement>
    </mads:elementList>
  </mads:Occupation>
</rdf:RDF>
END
    expect(subject.damsMetadata.content).to be_equivalent_to xml
  end

  it "should have occupationElement" do
    expect(subject.occupationElement.first.elementValue).to eq('Pharmacist')
  end

  it "should be able to build a new occupationElement" do
    subject.elementList.occupationElement.build
  end
end