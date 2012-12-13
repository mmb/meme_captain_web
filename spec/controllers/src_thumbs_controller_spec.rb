require 'spec_helper'

describe SrcThumbsController do

  describe "GET 'show'" do

    context 'when the id is found' do

      let(:src_thumb) {
        mock_model(SrcThumb)
      }

      it 'shows the thumbnail' do
        SrcThumb.should_receive(:find).and_return(src_thumb)

        get 'show', :id => 1

        expect(response).to be_success
      end

      it 'has the right content type' do
        src_thumb.should_receive(:content_type).and_return('content type')
        SrcThumb.should_receive(:find).and_return(src_thumb)

        get 'show', :id => 1

        expect(response.content_type).to eq('content type')
      end

      it 'has the right content' do
        src_thumb.should_receive(:image).and_return('image')
        SrcThumb.should_receive(:find).and_return(src_thumb)

        get 'show', :id => 1

        expect(response.body).to eq('image')
      end

    end

    context 'when the id is not found' do

      it 'raises record not found' do
        expect {
          get 'show', :id => 1
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

end
