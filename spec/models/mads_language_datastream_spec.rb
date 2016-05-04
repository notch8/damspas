# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsLanguageDatastream do

  describe "nested attributes" do
    it "should create a xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
      params = {
        language: {
          name: "French", code:"fre", externalAuthority: exturi,
          languageElement_attributes: [{ elementValue: "French" }],
          scheme_attributes: [
            id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
          ]
        }
      }

      subject = MadsLanguageDatastream.new(double("inner object", pid:"zzXXXXXXX1", new_record?: true))
      subject.attributes = params[:language]

      xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:Language rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>French</mads:authoritativeLabel>
    <mads:code>fre</mads:code>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
    <mads:elementList rdf:parseType="Collection">
      <mads:LanguageElement>
        <mads:elementValue>French</mads:elementValue>
      </mads:LanguageElement>
    </mads:elementList>
  </mads:Language>
</rdf:RDF>
END
      expect(subject.content).to be_equivalent_to xml
    end
    describe "a new instance" do
      subject { MadsLanguageDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXXXXX23")
      end

      it "should have a name" do
        subject.name = "French"
        expect(subject.name).to eq(["French"])
      end

      it "should have a code" do
        subject.name = "fre"
        expect(subject.name).to eq(["fre"])
      end
      
      it "should set the name (authoritativeLabel) when the elementList is set" do
        subject.name = "French"
        subject.languageElement_attributes = {'0' => { elementValue: "Test" }}
        expect(subject.name).to eq(["Test"])
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "French"
        subject.languageElement_attributes = [{ elementValue: nil }]
        expect(subject.name).to eq(["French"])
      end
    end

    describe "an instance with content" do
      subject do
        subject = MadsLanguageDatastream.new(double('inner object', :pid=>'xx00000006', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsLanguage.rdf.xml').read
        subject
      end

      it "should have name" do
        expect(subject.name).to eq(["French"])
      end

      it "should have code" do
        expect(subject.code).to eq(["fre"])
      end
      
      it "should have an scheme" do
        expect(subject.scheme.first.pid).to eq("bd71341600")
      end

      it "should have fields" do
        list = subject.elementList
        expect(list[0]).to be_kind_of MadsLanguageDatastream::MadsLanguageElement
        expect(list[0].elementValue).to eq("French")
        expect(list.size).to eq(1)
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["language_tesim"]).to eq(["French"])
        expect(solr_doc["language_element_tesim"]).to eq(["French"])
        expect(solr_doc["code_tesim"]).to eq(["fre"])
        expect(solr_doc["scheme_tesim"]).to eq(["#{Rails.configuration.id_namespace}bd71341600"])
        expect(solr_doc["scheme_name_tesim"]).to eq(["ISO 639 languages"])
      end
    end

  end
end
