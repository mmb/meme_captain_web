require 'spec_helper'

describe ApplicationHelper do

  describe '#thumbnail' do

    let(:model) { stub_model(SrcImage, :width => 10, :height => 20) }

    subject { helper.thumbnail(model) }

    it { include 'width="10"' }
    it { include 'height="10"' }
    it { include 'class="thumb img-polaroid"' }
    it { include "src=\"/src_images/#{model.id}\"" }
  end

end
