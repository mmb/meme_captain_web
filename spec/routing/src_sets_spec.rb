# encoding: UTF-8

describe 'src_sets routes' do
  context 'when the name has a unicode character' do
    it 'matches' do
      expect(get: "/src_sets/☃").to route_to(controller: 'src_set', id: '☃')
    end
  end

end
