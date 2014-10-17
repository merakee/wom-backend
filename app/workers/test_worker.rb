class HardWorker
  include Sidekiq::Worker

  # set option for worker
  # sidekiq_options :queue => :default, :retry => false, :backtrace => true
  def perform(count)
    puts "Test worker is counting: #{count}"
  end

  # ways to call worker
  # Worker.perform_async(1, 2, 3)
  # SomeClass.delay.some_class_method(1, 2, 3)                      # See Delayed Extensions wiki page
  # Sidekiq::Client.push('class' => Worker, 'args' => [1, 2, 3])  # Lower-level generic API
  # Sidekiq::Client.push('class' => 'Worker', 'args' => [1, 2, 3])  # Can also pass class as a string.

end