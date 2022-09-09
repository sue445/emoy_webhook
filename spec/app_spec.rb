describe App do
  describe "GET /" do
    subject { get "/" }

    it { should be_ok }
  end

  describe "POST /" do
    subject { post "/", payload, { "CONTENT_TYPE" => "application/json" } }

    before do
      allow(App).to receive(:post_slack)
    end

    context "when url_verification" do
      let(:payload) { fixture("url_verification.json") }

      it { should be_ok }
    end

    context "when emoji_changed" do
      context "when add" do
        let(:payload) { fixture("emoji_changed_add.json") }
        let(:message) { "A new emoji is added :picard_facepalm: `picard_facepalm`" }

        context "called once" do
          it { should be_ok }

          it "post_slack is called" do
            subject

            expect(App).to have_received(:post_slack).with(message)
          end
        end

        context "called twice" do
          before do
            post "/", payload, { "CONTENT_TYPE" => "application/json" }
          end

          context "with redis" do
            before do
              allow(App).to receive(:enabled_redis?) { true }
              allow(App).to receive(:enabled_firestore?) { false }
            end

            it { should be_ok }

            it "post_slack is called once" do
              subject

              expect(App).to have_received(:post_slack).with(message).once
            end
          end

          context "with firestore" do
            before do
              allow(App).to receive(:enabled_redis?) { false }
              allow(App).to receive(:enabled_firestore?) { true }
            end

            it { should be_ok }

            it "post_slack is called once" do
              subject

              expect(App).to have_received(:post_slack).with(message).once
            end
          end

          context "with no cache" do
            before do
              allow(App).to receive(:enabled_redis?) { false }
              allow(App).to receive(:enabled_firestore?) { false }
            end

            it { should be_ok }

            it "post_slack is called twice" do
              subject

              expect(App).to have_received(:post_slack).with(message).twice
            end
          end
        end
      end

      context "when add (alias)" do
        let(:payload) { fixture("emoji_changed_add_alias.json") }

        it { should be_ok }

        it "post_slack is called" do
          subject

          message = "A new emoji is added :picard_facepalm_alias: `picard_facepalm_alias` (alias of `picard_facepalm`)"
          expect(App).to have_received(:post_slack).with(message)
        end
      end

      context "when remove" do
        let(:payload) { fixture("emoji_changed_remove.json") }

        it { should be_ok }

        it "post_slack isn't called" do
          subject

          expect(App).not_to have_received(:post_slack)
        end
      end
    end
  end
end
