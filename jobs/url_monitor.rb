UrlMonitor.all.each do |s|
  Resque.enqueue(URLMonitorWorker, s.id)
end
