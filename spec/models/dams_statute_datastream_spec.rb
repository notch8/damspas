require 'spec_helper'

describe DamsStatuteDatastream do

  describe "a nested_attributes statute model" do

    it "should create a xml" do
      params = {
        statute: { citation: "Family Education Rights and Privacy Act (FERPA)",
			      jurisdiction: "us",
			      note: "Limits disclosure of student information.",
			      permission_node_attributes: [type: "display",beginDate: "2012-01-01",endDate: "2012-12-31"],
			      restriction_node_attributes: [type: "display",beginDate: "1993-12-31",endDate: "2043-12-31"]
        }
      }

      subject = DamsStatuteDatastream.new(double("inner object", pid:"zzXXXXXXX1", new_record?: true))
      subject.attributes = params[:statute]

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
      expect(subject.content).to be_equivalent_to xml
    end
    
    describe "instance populated in-memory" do

      subject { DamsStatuteDatastream.new(double('inner object', :pid=>'bbXXXXXX24', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXX24")
      end
      it "should have a citation" do
        subject.citation = "Family Education Rights and Privacy Act (FERPA)"
        expect(subject.citation).to eq(["Family Education Rights and Privacy Act (FERPA)"])
      end
      it "should have a jurisdiction" do
        subject.jurisdiction = "us"
        expect(subject.jurisdiction).to eq(["us"])
      end
      it "should have a note" do
        subject.note = "Limits disclosure of student information."
        expect(subject.note).to eq(["Limits disclosure of student information."])
      end
      it "should have a restriction begin date" do
        subject.restrictionBeginDate = "1993-12-31"
        expect(subject.restrictionBeginDate).to eq(["1993-12-31"])
      end
      it "should have a restriction end date" do
        subject.restrictionEndDate = "2043-12-31"
        expect(subject.restrictionEndDate).to eq(["2043-12-31"])
      end
      it "should have a restriction type" do
        subject.restrictionType = "display"
        expect(subject.restrictionType).to eq(["display"])
      end
      it "should have a permission begin date" do
        subject.permissionBeginDate = "1993-12-31"
        expect(subject.permissionBeginDate).to eq(["1993-12-31"])
      end
      it "should have a permission end date" do
        subject.permissionEndDate = "2043-12-31"
        expect(subject.permissionEndDate).to eq(["2043-12-31"])
      end
      it "should have a permission type" do
        subject.permissionType = "display"
        expect(subject.permissionType).to eq(["display"])
      end
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsStatuteDatastream.new(double('inner object', :pid=>'bb05050505', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsStatute.rdf.xml').read
        subject
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bb05050505")
      end
      it "should have a citation" do
        expect(subject.citation).to eq(["Family Education Rights and Privacy Act (FERPA)"])
      end
      it "should have a jurisdiction" do
        expect(subject.jurisdiction).to eq(["us"])
      end
      it "should have a note" do
        expect(subject.note).to eq(["Limits disclosure of student information."])
      end
      it "should have a restriciton begin date" do
        expect(subject.restrictionBeginDate).to eq(["1993-12-31"])
      end
      it "should have a restriciton end date" do
        expect(subject.restrictionEndDate).to eq(["2043-12-31"])
      end
      it "should have a restriction type" do
        expect(subject.restrictionType).to eq(["display"])
      end
      it "should have solr fields" do
        solr_doc = subject.to_solr
        expect(solr_doc["restrictionType_tesim"]).to eq(["display"])
        expect(solr_doc["restrictionBeginDate_tesim"]).to eq(["1993-12-31"])
        expect(solr_doc["restrictionEndDate_tesim"]).to eq(["2043-12-31"])
      end
    end
  end
end
