require 'rails_helper'

describe MemeCaptainWeb::TextMatchLambda do
  describe '#lambder' do
    subject(:text_match_lambda) { MemeCaptainWeb::TextMatchLambda.new }

    let(:o) { double('o') }
    let(:where) { double('where') }

    before do
      expect(ActiveRecord::Base.connection).to receive(
        :adapter_name
      ).and_return(adapter_name)
    end

    context 'when the database is Postgres' do
      let(:adapter_name) { 'PostgreSQL' }

      it 'uses Postgres full text search' do
        expect(o).to receive(:basic_search).with('query1').and_return(where)
        expect(where).to receive(:empty?).and_return(false)
        expect(text_match_lambda.lambder(o, 'column1').call('query1')).to eq(
          where
        )
      end

      context 'when the basic search returns no results' do
        it 'does a fuzzy search' do
          basic_where = double('basic_where')
          expect(basic_where).to receive(:empty?).and_return(true)
          expect(o).to receive(:basic_search).with('query1').and_return(
            basic_where
          )
          expect(o).to receive(:fuzzy_search).with('query1').and_return(where)
          expect(text_match_lambda.lambder(o, 'column1').call('query1')).to eq(
            where
          )
        end
      end
    end

    context 'when the database is not Postgres' do
      let(:adapter_name) { 'derpsql' }

      it 'uses SQL' do
        expect(o).to receive(:where).with(
          'LOWER(column1) LIKE ?', '%query1%'
        ).and_return(where)
        expect(text_match_lambda.lambder(o, 'column1').call('query1')).to eq(
          where
        )
      end
    end
  end
end
