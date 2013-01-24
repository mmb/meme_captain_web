require 'spec_helper'

describe 'src_sets/_src_set.html' do

  context 'the image has been processed' do
    it 'shows the thumbnail'
    it 'puts the width in the image tag'
    it 'puts the height in the image tag'
    it 'links to the source set'
  end

  context 'the image has not been processed yet' do
    it 'shows as under construction'
  end

end