@logger = Logger.new(STDOUT)

Domain.all.each do |d|
  Resque.enqueue(DashboardWorker, d.id)
end 
