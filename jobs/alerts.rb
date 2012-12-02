Domain.find_each do |d|
  d.alerts.each do |a|
    Resque.enqueue(AlertWorker, a.id)
  end
end
