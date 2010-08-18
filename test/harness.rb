$:<<'lib'
require 'logger'
require 'date'
require 'simple_scheduler'
require 'jobs/echo'

logger = Logger.new($stdout)
File.open("/tmp/schedule",File::RDWR|File::CREAT) do |file|
	scheduler = SimpleScheduler::Scheduler.new(:file => file, :logger => logger, :interval => 5)
	scheduler.start
	hello = Echo.new(:message => "Hello!", :when => Time.now)
	goodbye = Echo.new(:message => "Goodbye!", :when => Time.now + 6)
	# this next one will run the next time around
	back = Echo.new(:message=>"I'm baaaaaaack!", :when => Time.now + 20)
	scheduler << goodbye
	scheduler << hello
	scheduler << back
	sleep 15
	scheduler.stop
end