module SimpleScheduler
	
	module Mixins
		
		module Job
			
			attr_accessor :when
			
			def initialize(options)
				options.each do |key,value|
					instance_variable_set("@#{key}",value)
				end
			end
			
		end
		
	end

end