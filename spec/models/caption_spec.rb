require 'spec_helper'

describe Caption do

  it { should_not validate_presence_of :font }
  it { should allow_mass_assignment_of :font }

  it { should_not validate_presence_of :height_pct }
  it { should allow_mass_assignment_of :height_pct }

  it { should validate_presence_of :text }
  it { should allow_mass_assignment_of :text }

  it { should_not validate_presence_of :top_left_x_pct }
  it { should allow_mass_assignment_of :top_left_x_pct }

  it { should_not validate_presence_of :top_left_y_pct }
  it { should allow_mass_assignment_of :top_left_y_pct }

  it { should_not validate_presence_of :width_pct }
  it { should allow_mass_assignment_of :width_pct }

  it { should belong_to :gend_image }

end
