require 'thread'
require 'mixins/job'

module SimpleScheduler
	
	class Scheduler
		
		attr_accessor :logger
		
		def initialize(options)
			options.each do |key,value|
				instance_variable_set("@#{key}",value)
			end
			@queue = []
			@mutex = Mutex.new
		end
		
		def start
			restore
			@thread = Thread.new do
				loop do
					now = DateTime.now
					runnable, @queue = @queue.partition {|job| job.when<=now}
					runnable.each {|job| job.run(logger)}
					save
					sleep @interval
				end
			end
		end
		
		def stop
			return unless @thread
			sleep 1 until @thread.status == "sleep"
			@thread.kill
		end
		
		def <<(job)
			# if the job is unscheduled or in the past
			# just go ahead and run it now
			if job.when.nil? or job.when < DateTime.now
				job.run(logger)
			else
				# otherwise add it to the queue and save
				# the queue
				@queue << job
				save
			end
		end
		
		def restore
			begin
				@queue = Marshal.restore(@file)
			rescue => e
				logger.warn("Scheduler") { "Unable to restore queue from file, starting with an emtpy queue"}
				logger.warn("Scheduler") { e.to_s }
				@queue = []
			end
		end
		
		def save
			@mutex.synchronize do
				begin
					@file.rewind
					Marshal.dump(@queue,@file)
				rescue => e
					logger.warn("Scheduler") { "Unable to save queue to file, continuing with in-memory version only!"}
					logger.warn("Scheduler") { e.to_s }
				end
			end
		end
		
	end
	
end