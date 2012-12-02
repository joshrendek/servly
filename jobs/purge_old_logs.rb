ServerLog.find_each(:batch_size => 5000) do |s|
  if s.created_at < DateTime.now.advance(:months => -1)
    p "Deleteting #{s.created_at}"
    s.destroy
  end
end

CollectiveStat.find_each(:batch_size => 5000) do |s|
  if s.created_at < DateTime.now.advance(:months => -1)
    p "Deleteting #{s.created_at}"
    s.destroy
  end
end

UrlMonitorLog.find_each(:batch_size => 5000) do |s|
  if s.created_at < DateTime.now.advance(:months => -1)
    p "Deleteting #{s.created_at}"
    s.destroy
  end
end

MonitoredServiceLog.find_each(:batch_size => 5000) do |s|
  if s.created_at < DateTime.now.advance(:months => -1)
    p "Deleteting #{s.created_at}"
    s.destroy
  end
end


DiagnosticLog.find_each(:batch_size => 5000) do |s|
  if s.created_at < DateTime.now.advance(:months => -1)
    p "Deleteting #{s.created_at}"
    s.destroy
  end
end


TriggeredAlert.find_each(:batch_size => 5000) do |s|
  if s.created_at < DateTime.now.advance(:months => -1)
    p "Deleteting #{s.created_at}"
    s.destroy
  end
end
