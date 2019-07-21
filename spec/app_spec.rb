describe App do
  describe "GET /" do
    subject { get "/" }

    it { should be_ok }
  end

  describe "POST /" do
    subject { post "/", payload, { "CONTENT_TYPE" => "application/json" } }

    context "when url_verification" do
      let(:payload) { fixture("url_verification.json") }

      it { should be_ok }
    end
  end
end
