require 'spec_helper'

describe SrcSet do
  it { should allow_mass_assignment_of :name }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  it { should belong_to :user }
  it { should have_and_belong_to_many :src_images }
end
