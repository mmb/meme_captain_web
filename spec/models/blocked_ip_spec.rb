require 'rails_helper'

describe BlockedIp do
  include StatsD::Instrument::Matchers

  describe '.blocked?' do
    before do
      Rails.cache.clear
    end

    context 'when an ip is blocked' do
      it 'returns true' do
        FactoryGirl.create(:blocked_ip)
        expect(BlockedIp.blocked?('1.2.3.4')).to eq(true)
      end

      it 'increments the statsd counter' do
        FactoryGirl.create(:blocked_ip)
        expect do
          BlockedIp.blocked?('1.2.3.4')
        end.to trigger_statsd_increment('ip.blocked')
      end
    end

    context 'when an ip is not blocked' do
      it 'returns false' do
        FactoryGirl.create(:blocked_ip)
        expect(BlockedIp.blocked?('9.9.9.9')).to eq(false)
      end

      it 'does not increment the statsd counter' do
        FactoryGirl.create(:blocked_ip)
        expect do
          BlockedIp.blocked?('9.9.9.9')
        end.to_not trigger_statsd_increment('ip.blocked')
      end
    end

    it 'expires the cache after 5 minutes' do
      FactoryGirl.create(:blocked_ip)
      expect(BlockedIp.blocked?('1.2.3.4')).to eq(true)
      BlockedIp.delete_all
      expect(BlockedIp.blocked?('1.2.3.4')).to eq(true)
      Timecop.travel(Time.now + 360)
      expect(BlockedIp.blocked?('1.2.3.4')).to eq(false)
      FactoryGirl.create(:blocked_ip)
      expect(BlockedIp.blocked?('1.2.3.4')).to eq(false)
      Timecop.travel(Time.now + 360)
      expect(BlockedIp.blocked?('1.2.3.4')).to eq(true)
    end
  end
end
