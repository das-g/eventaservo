# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = "https://6b22c73cdd694a8b90f6b1d84ffa51df@o199541.ingest.sentry.io/1309834"
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end

  config.enabled_environments = %w[production staging]
end
