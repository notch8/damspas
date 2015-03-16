require 'spec_helper'

describe DamsProvenanceCollectionPartDatastream do

  describe "a provenance collection part model" do

    describe "instance populated in-memory" do

      subject { DamsProvenanceCollectionPartDatastream.new(double('inner object', :pid=>'xx25252525', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}xx25252525"
      end
      it "should have a title" do
        subject.titleValue = "May 2009"
        subject.titleValue.should == "May 2009"
      end
      it "should have a date" do
        subject.dateValue = "2009-05-03"
        subject.dateValue.should == ["2009-05-03"]
      end
      it "should have a visibility" do
        subject.visibility = "public"
        subject.visibility.should == ["public"]
      end
      it "should have a resource_type" do
        subject.resource_type = "text"
        subject.resource_type.should == ["text"]
      end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsProvenanceCollectionPartDatastream.new(double('inner object', :pid=>'xx25252525', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsProvenanceCollectionPart.rdf.xml').read
        subject
      end
      before(:all) do
        @prov = DamsProvenanceCollection.create(pid: 'xx24242424', titleValue: 'Historical Dissertations')
        @name = MadsPersonalName.create(pid: 'xx08080808', name: 'Artist, Alice, 1966-')
        @role = MadsAuthority.create(pid: 'xx55639754', name: 'Creator')
        @note1 = DamsNote.create(pid: 'xx52568274', value: 'Linked note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.')
        @note2 = DamsCustodialResponsibilityNote.create(pid: 'xx9113515d', value: 'Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.')
        @note3 = DamsPreferredCitationNote.create(pid: 'xx3959888k', value: 'Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.')
        @note4 = DamsScopeContentNote.create(pid: 'xx1366006j', value: 'Test Scope Content Note')
        @lang = MadsAuthority.create(pid: 'xx0410344f', name: 'English', code: 'eng')
      end
      after(:all) do
        @prov.delete
        @name.delete
        @role.delete
        @note1.delete
        @note2.delete
        @note3.delete
        @note4.delete
        @lang.delete
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}xx25252525"
      end
      it "should have a title" do
        subject.titleValue.should == "May 2009"
      end
      it "should have a date" do
        subject.beginDate.should == ["2009-05-03"]
        subject.endDate.should == ["2009-05-31"]
      end
      it "should have a visibility" do
        subject.visibility.should == ["public"]
      end
      it "should have a resource_type" do
        subject.resource_type.should == ["text"]
      end

 	  it "should index fields" do
        solr_doc = subject.to_solr
        solr_doc["title_tesim"].should == ["May 2009"]
        solr_doc["date_tesim"].should == ["2009-05-03","2009-05-31"]
        solr_doc["visibility_tesim"].should == ["public"]
        solr_doc["resource_type_tesim"].should == ["text"]
        solr_doc["unit_code_tesim"].should == ["rci"]
      end
 	  it "should have notes" do
        solr_doc = subject.to_solr
        solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "#{Rails.configuration.id_namespace}xx80808080"
        solr_doc["note_tesim"].should include "Linked note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end
      
      it "should have index notes" do
        solr_doc = subject.to_solr

 	    #it "should have scopeContentNote" do
		testIndexNoteFields solr_doc, "scopeContentNote","Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."

        #it "should have preferredCitationNote" do
		testIndexNoteFields solr_doc,"preferredCitationNote","Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."

        #it "should have CustodialResponsibilityNote" do
		testIndexNoteFields solr_doc, "custodialResponsibilityNote","Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end  
      it "should have relationship" do
        subject.relationship.first.name.first.pid.should == "xx08080808"
        subject.relationship.first.role.first.pid.should == "xx55639754"
        solr_doc = subject.to_solr
        solr_doc["name_tesim"].should include "Artist, Alice, 1966-"
      end       
      def testIndexNoteFields (solr_doc,fieldName,value)
        solr_doc["#{fieldName}_tesim"].should include "#{value}"
      end    	 
    end
  end
end
