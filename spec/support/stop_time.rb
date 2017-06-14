def stop_time(time = Time.zone.now)
  allow(Time).to receive(:now).and_return(time)
end
