Delayed::Worker.destroy_failed_jobs     = false
Delayed::Worker.sleep_delay             = 60
Delayed::Worker.max_attempts            = 8
Delayed::Worker.max_run_time            = 5.minutes
Delayed::Worker.delay_jobs              = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger                  = Logger.new(File.join(Rails.root, "log", "delayed_job.log"))
