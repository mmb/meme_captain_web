def stop_time(time = Time.now)
  allow(Time).to receive(:now).and_return(time)
end
