# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCopyright do
  subject do
    DamsCopyright.new pid: "bb05050505"
  end
  it "should create a xml" do
    subject.status = "Under copyright -- 3rd Party"
    subject.jurisdiction = "us"
    subject.purposeNote = "This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."
    subject.note = "This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by 'fair use' requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."
    subject.beginDate = "1993-12-31"

    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Copyright rdf:about="http://library.ucsd.edu/ark:/20775/bb05050505">
    <dams:copyrightStatus>Under copyright -- 3rd Party</dams:copyrightStatus>
    <dams:copyrightJurisdiction>us</dams:copyrightJurisdiction>
    <dams:copyrightPurposeNote>This work is available from the UC San Diego
        Libraries. This digital copy of the work is intended to support
        research, teaching, and private study.</dams:copyrightPurposeNote>
    <dams:copyrightNote>This work is protected by the U.S. Copyright Law (Title
        17, U.S.C.).  Use of this work beyond that allowed by 'fair use' 
        requires written permission of the copyright holder(s). Responsibility
        for obtaining permissions and any use and distribution of this work
        rests exclusively with the user and not the UC San Diego
        Libraries.</dams:copyrightNote>
    <dams:date>
      <dams:Date>
        <dams:beginDate>1993-12-31</dams:beginDate>
      </dams:Date>
    </dams:date>
  </dams:Copyright>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
