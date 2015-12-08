# encoding: UTF-8

require 'rails_helper'

describe GendImage do
  it { should validate_uniqueness_of :id_hash }

  it { should belong_to :src_image }

  it { should belong_to :user }

  it { should have_one :gend_thumb }

  it { should have_many :captions }

  it { should_not validate_presence_of :user }

  it 'should generate a unique id hash' do
    gend_image = FactoryGirl.create(:gend_image)
    expect(gend_image.id_hash).to_not be_nil
  end

  context 'setting fields derived from the image' do
    context 'when the image is not animated' do
      subject(:gend_image) { FactoryGirl.create(:gend_image) }

      specify { expect(gend_image.content_type).to eq('image/jpeg') }
      specify { expect(gend_image.height).to eq(399) }
      specify { expect(gend_image.width).to eq(399) }
      specify { expect(gend_image.size).to eq(9141) }
      specify { expect(gend_image.is_animated).to eq(false) }
    end

    context 'when the image is animated' do
      subject(:gend_image) { FactoryGirl.create(:animated_gend_image) }

      specify { expect(gend_image.is_animated).to eq(true) }
    end
  end

  describe '#ext' do
    let(:image) { File.read(Rails.root + 'spec/fixtures/files/ti_duck.jpg') }

    subject(:gend_image) do
      gend_image = GendImage.new(
        FactoryGirl.attributes_for(:gend_image, image: image))
      gend_image.valid?
      gend_image
    end

    context 'jpg' do
      specify { expect(gend_image.format).to eq(:jpg) }
    end

    context 'gif' do
      let(:image) { File.read(Rails.root + 'spec/fixtures/files/omgcat.gif') }

      specify { expect(gend_image.format).to eq(:gif) }
    end

    context 'png' do
      let(:image) { File.read(Rails.root + 'spec/fixtures/files/ti_duck.png') }

      specify { expect(gend_image.format).to eq(:png) }
    end

    context 'other' do
      it 'returns nil for extension' do
        subject.content_type = 'foo/bar'
        expect(subject.format).to be_nil
      end
    end
  end

  describe '#email' do
    let(:gend_image) { FactoryGirl.create(:gend_image) }

    it 'passes validation when email is nil' do
      gend_image.email = nil
      expect(gend_image).to be_valid
    end

    it 'passes validation when email is the empty string' do
      gend_image.email = ''
      expect(gend_image).to be_valid
    end

    it 'fails validation when email is set' do
      gend_image.email = 'bot@bots.com'
      expect(gend_image).to_not be_valid
    end
  end

  describe '#create_jobs' do
    let(:gend_image) { FactoryGirl.create(:gend_image) }
    before do
      gend_image.src_image.size = src_image_size
      gend_image.src_image.save!
    end

    context 'when the image is small' do
      let(:src_image_size) { 51_200 }

      it 'puts the image in the small queue' do
        gend_image_process_job = instance_double(GendImageProcessJob)
        expect(GendImageProcessJob).to receive(:new).with(
          gend_image.id).and_return(gend_image_process_job)
        expect(gend_image_process_job).to receive(:delay).with(
          queue: :gend_image_process_small).and_return(gend_image_process_job)
        expect(gend_image_process_job).to receive(:perform)

        gend_image.run_callbacks(:commit)
      end
    end

    context 'when the image is medium' do
      let(:src_image_size) { 575_488 }

      it 'puts the image in the small queue' do
        gend_image_process_job = instance_double(GendImageProcessJob)
        expect(GendImageProcessJob).to receive(:new).with(
          gend_image.id).and_return(gend_image_process_job)
        expect(gend_image_process_job).to receive(:delay).with(
          queue: :gend_image_process_medium).and_return(gend_image_process_job)
        expect(gend_image_process_job).to receive(:perform)

        gend_image.run_callbacks(:commit)
      end
    end

    context 'when the image is large' do
      let(:src_image_size) { 5_767_168 }

      it 'puts the image in the small queue' do
        gend_image_process_job = instance_double(GendImageProcessJob)
        expect(GendImageProcessJob).to receive(:new).with(
          gend_image.id).and_return(gend_image_process_job)
        expect(gend_image_process_job).to receive(:delay).with(
          queue: :gend_image_process_large).and_return(gend_image_process_job)
        expect(gend_image_process_job).to receive(:perform)

        gend_image.run_callbacks(:commit)
      end
    end

    context 'when the image is very large' do
      let(:src_image_size) { 10_485_761 }

      it 'puts the image in the small queue' do
        gend_image_process_job = instance_double(GendImageProcessJob)
        expect(GendImageProcessJob).to receive(:new).with(
          gend_image.id).and_return(gend_image_process_job)
        expect(gend_image_process_job).to receive(:delay).with(
          queue: :gend_image_process_shitload).and_return(
            gend_image_process_job)
        expect(gend_image_process_job).to receive(:perform)

        gend_image.run_callbacks(:commit)
      end
    end
  end

  describe '.caption_matches' do
    let(:caption1) { FactoryGirl.create(:caption, text: 'abc') }
    let(:caption2) { FactoryGirl.create(:caption, text: 'def') }
    before do
      @gend_image = FactoryGirl.create(
        :gend_image, captions: [caption1, caption2])
    end

    context "when one of the image's captions matches" do
      it 'returns the matching image' do
        expect(GendImage.caption_matches('b')).to eq([@gend_image])
      end
    end

    context "when one of the image's captions matches case insensitive" do
      it 'returns the matching image' do
        expect(GendImage.caption_matches('C')).to eq([@gend_image])
      end
    end

    context "when none of the image's captions matches" do
      it 'returns no matches' do
        expect(GendImage.caption_matches('g')).to eq([])
      end
    end

    context 'when both of the captions match' do
      let(:caption1) { FactoryGirl.create(:caption, text: 'abc') }
      let(:caption2) { FactoryGirl.create(:caption, text: 'cba') }

      it 'returns only one match' do
        expect(GendImage.caption_matches('C')).to eq([@gend_image])
      end
    end
  end

  describe '#meme_text' do
    it 'returns the captions joined in position order' do
      gend_image = FactoryGirl.create(:gend_image)
      gend_image.captions.create(
        text: 'test 1', top_left_x_pct: 9, top_left_y_pct: 20,
        width_pct: 0.9, height_pct: 0.25)
      gend_image.captions.create(
        text: 'test 2', top_left_x_pct: 10, top_left_y_pct: 20,
        width_pct: 0.9, height_pct: 0.25)
      gend_image.captions.create(
        text: 'test 3', top_left_x_pct: 7, top_left_y_pct: 7,
        width_pct: 0.9, height_pct: 0.25)
      gend_image.save!
      expect(gend_image.meme_text).to eq('test 3 test 1 test 2')
    end
  end

  describe '#meme_text_header' do
    subject(:gend_image) do
      FactoryGirl.create(:gend_image, captions: caption_models)
    end
    let(:caption_models) do
      captions.map { |text| FactoryGirl.create(:caption, text: text) }
    end

    context 'when there are no captions' do
      let(:captions) { [] }
      it 'returns the empty string' do
        expect(gend_image.meme_text_header).to eq('')
      end
    end

    context 'when there is one caption' do
      let(:captions) { ['caption 1'] }
      it 'returns the encoded caption' do
        expect(gend_image.meme_text_header).to eq('caption+1')
      end
    end

    context 'when there is more than one caption' do
      let(:captions) { ['caption 1', 'caption 2'] }
      it 'returns the encoded captions joined with an ampersand' do
        expect(gend_image.meme_text_header).to eq('caption+1&caption+2')
      end
    end
  end

  describe '.without_image' do
    it 'does not load the image data' do
      FactoryGirl.create(:gend_image)
      expect do
        GendImage.without_image.first.image
      end.to raise_error(ActiveModel::MissingAttributeError)
    end
  end

  describe '.caption_matches' do
    it 'finds images where the query is a subtring of one of the captions' do
      caption1 = FactoryGirl.create(:caption, text: 'the quick brown fox')
      caption2 = FactoryGirl.create(:caption, text: 'not a match')
      caption3 = FactoryGirl.create(:caption, text: 'fox brown quick the')
      gi1 = FactoryGirl.create(:gend_image, captions: [caption1, caption2])
      FactoryGirl.create(:gend_image, captions: [caption2])
      gi3 = FactoryGirl.create(:gend_image, captions: [caption2, caption3])
      expect(GendImage.caption_matches('quick')).to contain_exactly(gi1, gi3)
    end

    it 'it case insensitive' do
      caption1 = FactoryGirl.create(:caption, text: 'the quick brown fox')
      gi1 = FactoryGirl.create(:gend_image, captions: [caption1])
      expect(GendImage.caption_matches('QuIcK')).to contain_exactly(gi1)
    end

    it 'strips whitespace' do
      caption1 = FactoryGirl.create(:caption, text: 'the quick brown fox')
      gi1 = FactoryGirl.create(:gend_image, captions: [caption1])
      expect(GendImage.caption_matches(" quick\t\r\n")).to contain_exactly(gi1)
    end
  end

  describe '.publick' do
    it 'finds images that are not private' do
      gi1 = FactoryGirl.create(:gend_image, private: false)
      FactoryGirl.create(:gend_image, private: true)
      gi3 = FactoryGirl.create(:gend_image, private: false)
      expect(GendImage.publick).to contain_exactly(gi1, gi3)
    end
  end

  describe '.active' do
    it 'finds images that are not deleted' do
      FactoryGirl.create(:gend_image, is_deleted: true)
      gi2 = FactoryGirl.create(:gend_image, is_deleted: false)
      FactoryGirl.create(:gend_image, is_deleted: true)
      expect(GendImage.active).to contain_exactly(gi2)
    end
  end

  describe '.finished' do
    it 'finds images that are not in progress' do
      FactoryGirl.create(:gend_image, work_in_progress: true)
      gi2 = FactoryGirl.create(:gend_image, work_in_progress: false)
      gi3 = FactoryGirl.create(:gend_image, work_in_progress: false)
      expect(GendImage.finished).to contain_exactly(gi2, gi3)
    end
  end

  describe '.most_recent' do
    it 'order the images by most used' do
      gi1 = FactoryGirl.create(:gend_image)
      Timecop.travel(Time.now + 1)
      gi2 = FactoryGirl.create(:gend_image)
      Timecop.travel(Time.now + 1)
      gi3 = FactoryGirl.create(:gend_image)
      expect(GendImage.most_recent(3)).to eq([gi3, gi2, gi1])
    end
  end

  describe '.for_user' do
    let(:relation) { double(ActiveRecord::Relation) }
    let(:result) { double(ActiveRecord::Relation) }

    context 'when the user is nil' do
      let(:user) { nil }

      it 'returns images that are not private, deleted or in progress' do
        expect(GendImage).to receive(:without_image).and_return(relation)
        expect(relation).to receive(:includes).with(:gend_thumb).and_return(
          relation)
        expect(relation).to receive(:caption_matches).with('query').and_return(
          relation)
        expect(relation).to receive(:publick).and_return(relation)
        expect(relation).to receive(:active).and_return(relation)
        expect(relation).to receive(:finished).and_return(relation)
        expect(relation).to receive(:most_recent).and_return(relation)
        expect(relation).to receive(:page).with(1).and_return(result)
        expect(GendImage.for_user(user, 'query', 1)).to eq(result)
      end
    end

    context 'when the user is not an admin user' do
      let(:user) { FactoryGirl.create(:user) }

      it 'returns images that are not private, deleted or in progress' do
        expect(GendImage).to receive(:without_image).and_return(relation)
        expect(relation).to receive(:includes).with(:gend_thumb).and_return(
          relation)
        expect(relation).to receive(:caption_matches).with('query').and_return(
          relation)
        expect(relation).to receive(:publick).and_return(relation)
        expect(relation).to receive(:active).and_return(relation)
        expect(relation).to receive(:finished).and_return(relation)
        expect(relation).to receive(:most_recent).and_return(relation)
        expect(relation).to receive(:page).with(1).and_return(result)
        expect(GendImage.for_user(user, 'query', 1)).to eq(result)
      end
    end

    context 'when the user is an admin user' do
      let(:user) { FactoryGirl.create(:admin_user) }

      it 'returns all images' do
        expect(GendImage).to receive(:without_image).and_return(relation)
        expect(relation).to receive(:includes).with(:gend_thumb).and_return(
          relation)
        expect(relation).to receive(:caption_matches).with('query').and_return(
          relation)
        expect(relation).to receive(:most_recent).and_return(relation)
        expect(relation).to receive(:page).with(1).and_return(result)
        expect(GendImage.for_user(user, 'query', 1)).to eq(result)
      end
    end
  end
end
