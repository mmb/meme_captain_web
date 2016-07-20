require 'rails_helper'

describe MemeCaptainWeb::AnimatedGifCoalescer do
  subject(:animated_gif_coalescer) { MemeCaptainWeb::AnimatedGifCoalescer.new }
  let(:i) { instance_double(IO) }
  let(:o) { instance_double(IO) }
  let(:e) { instance_double(IO) }
  # this is not instance_double(Process::Waiter) because Process::Waiter is not
  # in ruby 2.1
  let(:t) { double('waiter') }
  let(:status) { instance_double(Process::Status) }

  describe '#coalesce' do
    context 'when the command succeeds' do
      let(:success) { true }

      it 'returns stdout from the command' do
        expect(Open3).to receive(:popen3).with(
          'convert - -coalesce -'
        ).and_yield(i, o, e, t)
        expect(i).to receive(:binmode)
        expect(o).to receive(:binmode)
        expect(i).to receive(:write).with('test data')
        expect(i).to receive(:close_write)
        expect(o).to receive(:read).and_return('output')
        expect(t).to receive(:value).and_return(status)
        expect(status).to receive(:success?).and_return(success)
        expect(animated_gif_coalescer.coalesce('test data')).to eq('output')
      end
    end

    context 'when the command fails' do
      let(:success) { false }

      it 'raises an exception with the stderr output' do
        expect(Open3).to receive(:popen3).with(
          'convert - -coalesce -'
        ).and_yield(i, o, e, t)
        expect(i).to receive(:binmode)
        expect(o).to receive(:binmode)
        expect(i).to receive(:write).with('test data')
        expect(i).to receive(:close_write)
        expect(o).to receive(:read)
        expect(t).to receive(:value).and_return(status)
        expect(status).to receive(:success?).and_return(success)
        expect(e).to receive(:read).and_return('test error')
        expect { animated_gif_coalescer.coalesce('test data') }.to raise_error(
          RuntimeError, 'test error'
        )
      end
    end

    it 'coalesces the image' do
      si = FactoryGirl.create(:animated_src_image)
      coalesced_image_data = animated_gif_coalescer.coalesce(si.image)
      coalesced_image = Magick::ImageList.new.from_blob(coalesced_image_data)
      coalesced_image.each do |frame|
        expect(frame.columns).to eq(300)
        expect(frame.rows).to eq(208)
      end
    end
  end
end
