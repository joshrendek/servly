Server.find_each do |s|
  Resque.enqueue(ServerStatusWorker, s.id)
end
