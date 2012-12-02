require 'spec_helper'

describe User do

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should allow_mass_assignment_of :email }
  it 'should validate that the email address is valid' do
  end

  it { should validate_confirmation_of :password }

  it { should validate_presence_of :password_digest }
  it { should_not allow_mass_assignment_of :password_digest }

  it { pending; should have_many :gend_image }
  it { pending; should have_many :src_image }

end
