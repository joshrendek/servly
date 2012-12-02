if Rails.env == 'production'
  Resque.redis = 'redis.servly.com:6379'
end
