require 'rails_helper'

describe DashboardHelper, type: :helper do
  describe '#format_system' do
    context 'when the variable name ends in _bytes' do
      it 'formats the value as bytes' do
        expect(helper.format_system(:some_bytes, 1_000_000)).to eq(
          [:some, '977 KB']
        )
      end
    end

    context 'when the variable has no special handling' do
      it 'returns unchanged' do
        expect(helper.format_system(:some_var, 'some value')).to eq(
          [:some_var, 'some value']
        )
      end
    end
  end
end
