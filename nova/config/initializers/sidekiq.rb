redis_host = ENV['REDIS_HOST'] || 'localhost'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{redis_host}:6379", namespace: 'sidekiq'  }
end
