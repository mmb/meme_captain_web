require 'rails_helper'

describe MemeCaptainWeb::ImgSizeConstrainer do
  subject(:img_size_constrainer) { MemeCaptainWeb::ImgSizeConstrainer.new }

  let(:img) { double('Magick::ImageList', columns: 50, rows: 50) }

  describe '#constrain_size' do
    context 'when the image is not animated' do
      before { allow(img).to receive(:animated?).and_return(false) }

      context 'when the longest side is small' do
        before do
          allow(img).to receive(:columns).and_return(20)
          allow(img).to receive(:rows).and_return(20)
          stub_const('MemeCaptainWeb::Config::MIN_SOURCE_IMAGE_SIDE', 50)
        end

        it 'enlarges the image' do
          stub_const('MemeCaptainWeb::Config::ENLARGED_SOURCE_IMAGE_SIDE', 200)
          expect(img).to receive(:resize_to_fit!).with(200)
          img_size_constrainer.constrain_size(img)
        end
      end
    end

    context 'when the image is animated' do
      before { allow(img).to receive(:animated?).and_return(true) }

      context 'when the image is too wide' do
        before do
          allow(img).to receive(:columns).and_return(200)
          allow(img).to receive(:rows).and_return(50)
          stub_const('MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE', 100)
        end

        it 'shrinks the image' do
          expect(img).to receive(:resize_to_fit_anim!).with(100)
          img_size_constrainer.constrain_size(img)
        end
      end

      context 'when the image is too high' do
        before do
          allow(img).to receive(:columns).and_return(50)
          allow(img).to receive(:rows).and_return(200)
          stub_const('MemeCaptainWeb::Config::MAX_SOURCE_IMAGE_SIDE', 100)
        end

        it 'shrinks the image' do
          expect(img).to receive(:resize_to_fit_anim!).with(100)
          img_size_constrainer.constrain_size(img)
        end
      end
    end
  end
end
