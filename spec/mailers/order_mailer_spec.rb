require "spec_helper"

describe OrderMailer do
  describe "processed" do
    let(:mail) { OrderMailer.processed }

    it "renders the headers" do
      mail.subject.should eq("Processed")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
