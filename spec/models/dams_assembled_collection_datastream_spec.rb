require 'spec_helper'

describe DamsAssembledCollectionDatastream do

  describe "an assembled collection model" do

    describe "instance populated in-memory" do

      subject { DamsAssembledCollectionDatastream.new(double('inner object', :pid=>'bb03030303', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb03030303"
      end
      it "should have a title" do
        subject.titleValue = "UCSD Electronic Theses and Dissertations"
        subject.titleValue.should == "UCSD Electronic Theses and Dissertations"
      end
      it "should have a date" do
        subject.dateValue = "2009-05-03"
        subject.dateValue.should == ["2009-05-03"]
      end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsAssembledCollectionDatastream.new(double('inner object', :pid=>'bb03030303', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsAssembledCollection2.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb03030303"
      end
      it "should have a title" do
        subject.titleValue.should == "UCSD Electronic Theses and Dissertations"
      end
      it "should have a date" do
        subject.beginDate.should == ["2009-05-03"]
      end

 	  it "should index title and dates" do
        solr_doc = subject.to_solr
        solr_doc["title_tesim"].should == ["UCSD Electronic Theses and Dissertations"]
        solr_doc["date_tesim"].should == ["2009-05-03"]
      end

 	  it "should have scopeContentNote" do
        solr_doc = subject.to_solr
        solr_doc["scopeContentNote_tesim"].to_s.should include "Inline scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["scopeContentNote_tesim"].to_s.should include "Linked scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end

 	  it "should have notes" do
        solr_doc = subject.to_solr
        solr_doc["note_tesim"].to_s.should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].to_s.should include "#{Rails.configuration.id_namespace}bb80808080"
      end

      it "should have preferredCitationNote" do
		testIndexNoteFields "preferredCitationNote","Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end
      it "should have CustodialResponsibilityNote" do
		testIndexNoteFields "custodialResponsibilityNote","Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end
      it "should have relationship" do
        subject.relationship.first.name.first.pid.should == "bb08080808"
        subject.relationship.first.role.first.pid.should == "bd55639754"
        solr_doc = subject.to_solr
        solr_doc["name_tesim"].should == ["Artist, Alice, 1966-"]
      end
#      it "should have event" do
#        solr_doc = subject.to_solr
#        solr_doc["event_1_type_tesim"].should == ["collection creation"]
#        solr_doc["event_1_eventDate_tesim"].should == ["2012-11-06T09:26:34-0500"]
#        solr_doc["event_1_outcome_tesim"].should == ["success"]
#        solr_doc["event_1_name_tesim"].should == ["Administrator, Bob, 1977-"]
#        solr_doc["event_1_role_tesim"].should == ["Initiator"]
#      end
      def testIndexNoteFields (fieldName,value)
        solr_doc = subject.to_solr
        solr_doc["#{fieldName}_tesim"].to_s.should include value
      end

    end
  end
end
