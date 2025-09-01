Sidekiq.configure_server do |config|
    config.on(:startup) do
      schedule_file = "config/sidekiq_schedule.yml"
  
      if File.exist?(schedule_file)
        Sidekiq.schedule = YAML.load_file(schedule_file)
        Sidekiq::Scheduler.reload_schedule!
        Rails.logger.info "Loaded Sidekiq schedule from #{schedule_file}"
      else
        Rails.logger.warn "Sidekiq schedule file not found: #{schedule_file}"
      end
    end
  end
  