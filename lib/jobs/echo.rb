class Echo
	
	include SimpleScheduler::Mixins::Job
	
	attr_accessor :message
	
	def run(logger)
		logger.info("Echo") { message }
	end
	
end