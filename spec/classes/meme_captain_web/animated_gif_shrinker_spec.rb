require 'rails_helper'

describe MemeCaptainWeb::AnimatedGifShrinker do
  include StatsD::Instrument::Matchers

  subject(:animated_gif_shrinker) do
    MemeCaptainWeb::AnimatedGifShrinker.new(coalescer, trimmer)
  end

  let(:coalescer) { instance_double(MemeCaptainWeb::AnimatedGifCoalescer) }
  let(:trimmer) { instance_double(MemeCaptainWeb::AnimatedGifTrimmer) }

  describe '#shrink' do
    context 'when the image is small enough' do
      let(:image_data) { 'abc' }
      let(:max_size) { 4 }

      it 'does not yield' do
        expect do |b|
          animated_gif_shrinker.shrink(image_data, max_size, &b)
        end.to_not yield_control
      end

      it 'returns nil' do
        expect(animated_gif_shrinker.shrink(image_data, max_size)).to be_nil
      end
    end

    context 'when the image needs to be shrunk' do
      let(:image_data) { 'GIFdata' }
      let(:max_size) { 2 }

      it 'coalesces the image' do
        expect(coalescer).to receive(:coalesce).with('GIFdata').and_return(
          'GIFdatacoalesced'
        )
        allow(trimmer).to receive(:trim).with('GIFdatacoalesced').and_return(
          'x'
        )
        animated_gif_shrinker.shrink(image_data, max_size) {}
      end

      it 'yields the trimmed data' do
        allow(coalescer).to receive(:coalesce).with('GIFdata').and_return(
          'GIFdatacoalesced'
        )
        allow(trimmer).to receive(:trim).with('GIFdatacoalesced').and_return(
          'x'
        )
        expect do |b|
          animated_gif_shrinker.shrink(image_data, max_size, &b)
        end.to yield_with_args('x')
      end

      it 'returns nil' do
        allow(coalescer).to receive(:coalesce).with('GIFdata').and_return(
          'GIFdatacoalesced'
        )
        allow(trimmer).to receive(:trim).with('GIFdatacoalesced').and_return(
          'x'
        )
        expect(
          animated_gif_shrinker.shrink(image_data, max_size) {}
        ).to be_nil
      end

      it 'increments the statsd success counter' do
        allow(coalescer).to receive(:coalesce).with('GIFdata').and_return(
          'GIFdatacoalesced'
        )
        allow(trimmer).to receive(:trim).with('GIFdatacoalesced').and_return(
          'x'
        )
        expect do
          animated_gif_shrinker.shrink(image_data, max_size) {}
        end.to trigger_statsd_increment('animated_gif_shrinker.shrink.success')
      end

      it 'sends a statsd time measurement' do
        allow(coalescer).to receive(:coalesce).with('GIFdata').and_return(
          'GIFdatacoalesced'
        )
        allow(trimmer).to receive(:trim).with('GIFdatacoalesced').and_return(
          'x'
        )
        expect do
          animated_gif_shrinker.shrink(image_data, max_size) {}
        end.to trigger_statsd_measure('animated_gif_shrinker.shrink.runtime')
      end
    end

    context 'when multiple passes are required' do
      let(:image_data) { 'GIFdata' }
      let(:max_size) { 3 }

      it 'yields the trimmed data' do
        allow(coalescer).to receive(:coalesce).with('GIFdata').and_return(
          'GIFdatacoalesced'
        )
        allow(trimmer).to receive(:trim).with('GIFdatacoalesced').and_return(
          'xxxx'
        )
        allow(trimmer).to receive(:trim).with('GIFdatacoalesced').and_return(
          'xxx'
        )
        expect do |b|
          animated_gif_shrinker.shrink(image_data, max_size, &b)
        end.to yield_with_args('xxx')
      end

      it 'returns nil' do
        allow(coalescer).to receive(:coalesce).with('GIFdata').and_return(
          'GIFdatacoalesced'
        )
        allow(trimmer).to receive(:trim).with('GIFdatacoalesced').and_return(
          'x'
        )
        expect(
          animated_gif_shrinker.shrink(image_data, max_size) {}
        ). to be_nil
      end
    end

    context 'when shrinking raises an exception' do
      let(:image_data) { 'GIFdata' }
      let(:max_size) { 4 }

      before do
        expect(coalescer).to receive(:coalesce).with('GIFdata').and_raise(
          'error'
        )
      end

      it 'increments the statsd failure counter' do
        expect do
          begin
            animated_gif_shrinker.shrink(image_data, max_size) {}
          rescue StandardError => e
            e
          end
        end.to trigger_statsd_increment('animated_gif_shrinker.shrink.failure')
      end
    end
  end
end
