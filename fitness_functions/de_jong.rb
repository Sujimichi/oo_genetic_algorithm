module ArrayMaths
	
	def each!
		self.each_with_index do |n,i|
			self[i] = yield n
		end
	end

	def sum 
		y = 0
		self.each {|n| y+=n}
		y
	end

	def do_to_each action, action_args = nil
		self.each_with_index do |n, i| 
			self[i] = n.send(action) unless action_args
			self[i] = n.send(action, action_args) if action_args
		end
	end

end

class Array
	include ArrayMaths
end

class DeJongSuite

	def run_test test_number, x
		x = [x] unless x.class == Array
		x.each! {|i| i += 0.00 }
		send("de_jong_#{test_number}", x)
		@fv
	end


	def de_jong_1 x
		x.each! {|i| i**2}
		@fv = x.sum
	end

	def de_jong_2 x
		n = []
		(x.size-1).times do |i|
			n[i] = 100 * ( x[i]**2 - x[i+1] )**2 + (1 - x[i])**2
		end
		@fv = n.sum
	end

	def de_jong_3 x 
		n = []
		x.each! {|i| i.round}
		@fv = x.sum
	end

	def de_fong_4


	end

	def de_jong_5


	end


end

