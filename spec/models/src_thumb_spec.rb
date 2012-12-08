require 'spec_helper'

describe SrcThumb do
  it { should validate_presence_of :format }
  it { should allow_mass_assignment_of :format }

  it { should validate_presence_of :height }
  it { should allow_mass_assignment_of :height }

  it { should validate_presence_of :image }
  it { should allow_mass_assignment_of :image }

  it { should validate_presence_of :size }
  it { should allow_mass_assignment_of :size }

  it { should validate_presence_of :width }
  it { should allow_mass_assignment_of :width }

  it { should belong_to :src_image }
end
