# encoding: UTF-8

require 'rails_helper'

describe Api::V3::PendingGendImagesController, type: :controller do
  include StatsD::Instrument::Matchers

  describe "GET 'show'" do
    let(:gend_image) { FactoryGirl.create(:gend_image) }

    context 'when the image is not found' do
      it 'returns not found status' do
        expect do
          get(:show, id: 'does-not-exist')
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'increments the statsd failure counter' do
        expect do
          begin
            get(:show, id: 'does-not-exist')
          rescue ActiveRecord::RecordNotFound => e
            e
          end
        end.to trigger_statsd_increment('api.v3.gend_image.create.poll.failure')
      end
    end

    context 'when the image has been deleted' do
      let(:gend_image) do
        FactoryGirl.create(:gend_image, is_deleted: true)
      end

      it 'returns not found status' do
        expect do
          get(:show, id: 'does-not-exist')
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'increments the statsd failure counter' do
        expect do
          begin
            get(:show, id: gend_image.id_hash)
          rescue ActiveRecord::RecordNotFound => e
            e
          end
        end.to trigger_statsd_increment('api.v3.gend_image.create.poll.failure')
      end
    end

    context 'when the image is found' do
      context 'when the image is still being processed' do
        it 'returns success' do
          get(:show, id: gend_image.id_hash)
          expect(response).to be_success
        end

        it 'increments the statsd success counter' do
          expect do
            get(:show, id: gend_image.id_hash)
          end.to trigger_statsd_increment(
            'api.v3.gend_image.create.poll.success')
        end

        it 'returns json with the created time' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(Time.parse(parsed_json['created_at']).to_i).to eq(
            gend_image.created_at.to_i)
        end

        it 'returns json with the error field set to null' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['error']).to be_nil
        end

        it 'returns json with the in_progress field set to true' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['in_progress']).to eq(true)
        end

        it 'returns json with the url field set to null' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['url']).to be_nil
        end
      end

      context 'when there was an error processing the image' do
        let(:gend_image) do
          FactoryGirl.create(:gend_image, error: 'an error occurred')
        end

        it 'returns success' do
          get(:show, id: gend_image.id_hash)
          expect(response).to be_success
        end

        it 'increments the statsd success counter' do
          expect do
            get(:show, id: gend_image.id_hash)
          end.to trigger_statsd_increment(
            'api.v3.gend_image.create.poll.success')
        end

        it 'returns json with the created time' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(Time.parse(parsed_json['created_at']).to_i).to eq(
            gend_image.created_at.to_i)
        end

        it 'returns json with the error' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['error']).to eq('an error occurred')
        end

        it 'returns json with the in_progress field set to false' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['in_progress']).to eq(false)
        end

        it 'returns json with the url field set to null' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['url']).to be_nil
        end
      end

      context 'when the image is finished being processed' do
        let(:gend_image) do
          FactoryGirl.create(:gend_image, work_in_progress: false)
        end

        it 'returns success' do
          get(:show, id: gend_image.id_hash)
          expect(response).to be_success
        end

        it 'increments the statsd success counter' do
          expect do
            get(:show, id: gend_image.id_hash)
          end.to trigger_statsd_increment(
            'api.v3.gend_image.create.poll.success')
        end

        it 'returns json with the created time' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(Time.parse(parsed_json['created_at']).to_i).to eq(
            gend_image.created_at.to_i)
        end

        it 'returns json with the error field set to null' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['error']).to be_nil
        end

        it 'returns json with the in_progress field set to false' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['in_progress']).to eq(false)
        end

        it 'returns json with the url field set' do
          get(:show, id: gend_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['url']).to eq(
            "http://test.host/gend_images/#{gend_image.id_hash}.jpg")
        end
      end
    end
  end
end
