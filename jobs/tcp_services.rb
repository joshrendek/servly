Domain.all.each do |d|
  # check server status's ... if down order a ping and traceroute!
  @services = d.services.where(:service_type => 'tcp')
  @services.each do |s|
    Resque.enqueue(TcpServicesWorker, s.id)
  end
end # end subdomain loop
