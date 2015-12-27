require 'rails_helper'

describe NoResultSearch, type: :model do
  it 'has a query field' do
    NoResultSearch.create(query: 'test query')
  end
end
