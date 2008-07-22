#BinaryFunctions module is used in the Fitness Model for decoding binary genomes
module BinaryFunctions
	#take a bin genome and forces it into n seperate groups.  
	#All groups will be equal in size except for the last one which 
	#will compensate for uneven divisions
	def split_bin_by_n n = 3
		dna = self.genome.sequence
		l = dna.size
		e = l/n
		s = 0
		out =  []
		n.times do |i|
			out << dna[s..(l-1)] if n==(i+1)
			out << dna[s..(s+(e-1))] unless n==(i+1)
			s += e
		end
		out
	end

	#Take a binary genome and divide it into groups of the same size
	#Will make as make groups as posible with the genome.  Any genes left over are ignored
	def split_bin_into_n n = 4
		bin = self.genome.sequence
		out = []
		(bin.size/n).times do |i|
			s = (i*(n))
			e = ((i*(n))+ n-1)
			out << bin[s..e] unless e > bin.size
		raise "#{s}, #{e}, #{n-1}" if (e-s) != (n-1)
		end
	out
	end
	

	#Convert array of arrays containing 1 & 0's and make array of int values. 
	def bin_to_int bins #an array of arrays; [[1,0,0],[1,0,1]]
		ints = []
		bins.each do |bin_seq|
			m = bin_seq.size
			b = 1			#b => binary vals, will go from 1 -> 2 -> 4 -> 8 etc
			d = 0			#d => the decimal out
			(m-1).times do |j| #-1 to ignore first bin digit
				bit = bin_seq.pop #starting from the right get next value
				d += (bit * b)		#multiply with b to give int value and and to total
				b = b*2						#update the bin val to next pos (double)
			end
			d = -d if bin_seq.pop == 1 #first bin digit sets the sign 
			ints.push d
		end
		ints
	end
end

#This Fitness module for use with the Individual class.  This allows for 
#Individual.fitness to return the fitess based on the genome of the ind
#and the fitness function selected in the configs

module Fitness
	include BinaryFunctions

#----------------Fitness Function Helpers----------------#
	#These function are not the actuall fitness functions 
	#but handle the calling of them and return thier output
	def fitness
		@fitness = evaluate unless @fitness
		@fitness
	end

	def fitness_target 
		puts "No Fitness Target specified" unless @fitness_target
		@fitness_target
	end


	def fitness_target= i
		@fitness_target = i
	end

	def phenotype
		fitness unless @phenotype 
		@phenotype ||= "not avaliable" 
		@phenotype
	end

	def evaluate
		if @config[:fitness_function].to_s=~/inverse/
			f = -send(@config[:fitness_function].to_s.sub("inverse_",""))
		else
			f = send(@config[:fitness_function])
		end
	end


#--------------------Fitness Functions--------------------#
	#The following functions are the available fitnessfunctions 
	#for this GA.  Others can be added easily as new methods 
	#with are called by in the ga by setting 
	#@confing[:fitness_function] => <my_fitess_func>

	def genome_sum
		self.genome.sequence.sum
	end
	alias max_ones genome_sum

	def de_jong
		require "fitness_functions\\de_jong.rb"
		d = DeJongSuite.new
		t = d.run_test 2, self.genome.sequence
		t
	end



	def bin_sim_eq_1
		bins = split_bin_into_n 4
		vals = bin_to_int bins
		sim_eq_1 vals
	end

	def bin_string
		bins = split_bin_into_n 2
		puts bins.inspect
		vals = bin_to_int bins

		h={0 => "x", 1 => "^", 2 => "^", 3 => 2}
		pheno = []
		for v in vals

		end

	end

	def sim_eq_1 variables = nil
		@fitness_target = 0
		# 5x + 2y + z = 38
		# 2x + 9y - z = 67
		unless variables
			dna = self.genome.sequence
			x = dna[0]
			y = dna[1]
			z = dna[2]	
		else
			@phenotype = variables
			x = variables[0]
			y = variables[1]
			z = variables[2]
		end
		a = 5*x + 2*y + z
		b = 2*x + 9*y - z
		dif_a = (38 - a).abs
		dif_b = (67 - b).abs
		fv = -(dif_a + dif_b)
		fv
	end

	def sim_eq_2
		@fitness_target = 0
		dna = self.genome.sequence
		x = dna[0].to_f
		y = dna[1].to_f
		a = 2*x + 3*y 
		b = 4*x - 6*y 

		dif_a = (6.0 - a).abs 
		dif_b = (-4.0 - b).abs 

		fv = -(dif_a + dif_b)
		fv
	end


	def sim_eq_3
		@fitness_target = 0
		#w = 6, x = 5, y = 2, z = 4
		dna = self.genome.sequence
		w = dna[0].to_f
		x = dna[1].to_f
		y = dna[2].to_f
		z = dna[3].to_f

		a = (2*x + w)/ (y-z) #rescue -1000
		b = ((w*z)/5) - (x/y)	#rescue -1000

		dif_a = (-8.0 - a).abs 
		dif_b = (2.3 - b).abs 

		fv = -(dif_a + dif_b)

		raise fv.inspect if fv.class.inspect != "Float"
		fv
	end

	def equation 
	
	end



end
