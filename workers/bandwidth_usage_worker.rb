class BandwidthUsageWorker
  @queue = :bandwidth_usage

  # Expects id
  def self.perform(server_id)
    Server.bandwidth_usage(server_id)
  end
end
