class ApplicationWorker
  include Sidekiq::Worker

  # example: ApplicationWorker.perform_async
  def perform
    Rails.logger.info "[Rails Worker] class: #{self.class}; Welcome to Workers"
  end
end
