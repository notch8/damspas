require 'spec_helper'

describe DamsCopyrightDatastream do

  describe "nested attributes" do
    it "should create a xml" do
      params = {
        copyright: {
          status: "Under copyright", 
          jurisdiction: "us",
          purposeNote: "This work is available from the UC San Diego Libraries",
          note: "This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).",
          date_attributes: [
            beginDate: "1993-12-31"
          ]
        }
      }

      subject = DamsCopyrightDatastream.new(double("inner object", pid:"zzXXXXXXX1", new_record?: true))
      subject.attributes = params[:copyright]

      xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <dams:Copyright rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <dams:copyrightJurisdiction>us</dams:copyrightJurisdiction>
    <dams:copyrightNote>This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).</dams:copyrightNote>
    <dams:copyrightPurposeNote>This work is available from the UC San Diego Libraries</dams:copyrightPurposeNote>
    <dams:copyrightStatus>Under copyright</dams:copyrightStatus>    
    <dams:date>
      <dams:Date>
        <dams:beginDate>1993-12-31</dams:beginDate>
      </dams:Date>
    </dams:date>
  </dams:Copyright>
</rdf:RDF>
END
      expect(subject.content).to be_equivalent_to xml
    end

    describe "instance populated in-memory" do

      subject { DamsCopyrightDatastream.new(double('inner object', :pid=>'bbXXXXXX24', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXX24")
      end
      it "should have a status" do
        subject.status = "Under copyright"
        expect(subject.status).to eq(["Under copyright"])
      end
      it "should have a jurisdiction" do
        subject.jurisdiction = "us"
        expect(subject.jurisdiction).to eq(["us"])
      end
      it "should have a purpose note" do
        subject.purposeNote = "This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."
        expect(subject.purposeNote).to eq(["This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."])
      end
      it "should have a note" do
        subject.note = "This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by 'fair use' requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."
        expect(subject.note).to eq(["This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by 'fair use' requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."])
      end
      it "should have a begin date" do
        subject.beginDate = "1993-12-31"
        expect(subject.beginDate).to eq(["1993-12-31"])
      end
    end


    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsCopyrightDatastream.new(double('inner object', :pid=>'bb05050505', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsCopyright.rdf.xml').read
        subject
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bb05050505")
      end
      it "should have a status" do
        expect(subject.status).to eq(["Under copyright"])
      end
      it "should have a jurisdiction" do
        expect(subject.jurisdiction).to eq(["us"])
      end
      it "should have a purpose note" do
        expect(subject.purposeNote).to eq(["This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."])
      end
      it "should have a note" do
        expect(subject.note).to eq(["This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by 'fair use' requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."])
      end
      it "should have a begin date" do
        expect(subject.beginDate).to eq(["1993-12-31"])
      end
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["status_tesim"]).to eq(["Under copyright"])
        expect(solr_doc["jurisdiction_tesim"]).to eq(["us"])
        expect(solr_doc["beginDate_tesim"]).to eq(["1993-12-31"])
        expect(solr_doc["purposeNote_tesim"]).to eq(["This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."])
      end
    end
  end
end
