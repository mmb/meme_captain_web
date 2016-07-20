require 'rails_helper'

describe SrcImageNameJob do
  subject(:src_image_name_job) { SrcImageNameJob.new(src_image.id) }
  let(:src_image) { FactoryGirl.create(:src_image, name: current_name) }
  let(:x) { double(:x) }
  let(:lookup_host) { nil }
  let(:current_name) { nil }
  let(:google_image_namer) { instance_double(MemeCaptainWeb::GoogleImageNamer) }

  before do
    allow(Rails.configuration).to receive(:x).and_return(x)
    allow(x).to receive(:src_image_name_lookup_host).and_return(lookup_host)
    allow(MemeCaptainWeb::GoogleImageNamer).to receive(:new).and_return(
      google_image_namer
    )
  end

  context 'when src image name lookups are turned off' do
    it 'does not change the src image name' do
      expect do
        src_image_name_job.perform
      end.to_not change { src_image.name }
    end
  end

  context 'when src image name lookups are turned on' do
    let(:lookup_host) { 'test.com' }

    context 'when the src image is private' do
      let(:src_image) do
        FactoryGirl.create(:src_image, private: true, name: '')
      end

      it 'does not change the src image name' do
        expect do
          src_image_name_job.perform
        end.to_not change { src_image.name }
      end
    end

    context 'when the src image already has a name' do
      let(:current_name) { 'current name' }

      it 'does not change the src image name' do
        expect do
          src_image_name_job.perform
        end.to_not change { src_image.name }
      end
    end

    context 'when the src image name is nil' do
      let(:current_name) { nil }

      context 'when the Google image namer returns nil' do
        before do
          allow(google_image_namer).to receive(:name).with(
            "http://test.com/src_images/#{src_image.id_hash}"
          ).and_return(nil)
        end

        it 'does not change the src image name' do
          expect do
            src_image_name_job.perform
          end.to_not change { src_image.name }
        end
      end

      context 'when Google can identify the image' do
        before do
          allow(google_image_namer).to receive(:name).with(
            "http://test.com/src_images/#{src_image.id_hash}"
          )
            .and_return('test image')
        end

        it "sets the name to Google's description of the image" do
          expect do
            src_image_name_job.perform
            src_image.reload
          end.to change { src_image.name }.to('test image')
        end
      end
    end

    context 'when the src image name is empty' do
      let(:current_name) { '' }

      context 'when Google can identify the image' do
        before do
          allow(google_image_namer).to receive(:name).with(
            "http://test.com/src_images/#{src_image.id_hash}"
          )
            .and_return('test image')
        end

        it "sets the name to Google's description of the image" do
          expect do
            src_image_name_job.perform
            src_image.reload
          end.to change { src_image.name }.to('test image')
        end
      end
    end
  end

  describe '#max_attempts' do
    it 'is 1' do
      expect(src_image_name_job.max_attempts).to eq(1)
    end
  end
end
