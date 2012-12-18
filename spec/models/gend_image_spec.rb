require 'spec_helper'

describe GendImage do

  it { should validate_presence_of :id_hash }

  it { should belong_to :src_image }

  it { pending; should have_many :caption_text }
end
