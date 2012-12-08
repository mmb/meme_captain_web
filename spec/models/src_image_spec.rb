require 'spec_helper'

describe SrcImage do
  it { should validate_presence_of :format }
  it { should allow_mass_assignment_of :format }

  it { should validate_presence_of :height }
  it { should allow_mass_assignment_of :height }

  it { should validate_presence_of :id_hash }
  it { should allow_mass_assignment_of :id_hash }
  it { should validate_uniqueness_of :id_hash }

  it { should validate_presence_of :image }
  it { should allow_mass_assignment_of :image }

  it { should validate_presence_of :size }
  it { should allow_mass_assignment_of :size }

  it { should_not validate_presence_of :url }
  it { should allow_mass_assignment_of :url }

  it { should validate_presence_of :width }
  it { should allow_mass_assignment_of :width }


  it { should belong_to :user }
  it { should have_one :src_thumb }
end
