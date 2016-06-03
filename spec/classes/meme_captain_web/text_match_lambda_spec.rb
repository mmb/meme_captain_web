require 'rails_helper'

describe MemeCaptainWeb::TextMatchLambda do
  describe '#lambda' do
    subject(:text_match_lambda) do
      MemeCaptainWeb::TextMatchLambda.new(o, 'column1')
    end

    let(:o) { double }
    let(:where) { double }

    before do
      expect(ActiveRecord::Base.connection).to receive(
        :adapter_name).and_return(adapter_name)
    end

    context 'when the database is Postgres' do
      let(:adapter_name) { 'PostgreSQL' }

      it 'uses Postgres full text search' do
        expect(o).to receive(:where).with(
          'column1 @@ PLAINTO_TSQUERY(?)', 'query1').and_return(where)
        expect(text_match_lambda.lambder.call('query1')).to eq(where)
      end
    end

    context 'when the database is not Postgres' do
      let(:adapter_name) { 'derpsql' }

      it 'uses SQL' do
        expect(o).to receive(:where).with(
          'LOWER(column1) LIKE ?', '%query1%').and_return(where)
        expect(text_match_lambda.lambder.call('query1')).to eq(where)
      end
    end
  end
end
