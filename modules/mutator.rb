#This Module provides various methods for mutation for use with Genome class 
#which one is run is defined in @config[:mutate_type]
module Mutator
	def mutate
		@mutant = true
		send @mutate_type
	end

	def bit_flip
		loci = select_loci
		@dna[loci] = (@dna[loci] - 1).abs
	end

	def decimal_shift
		@shift_strength ||= 1
		loci = select_loci
		@dna[loci] = ((rand > 0.5) ? (@dna[loci] + shift) : (@dna[loci] - shift))
	end
		
	def integer_shift 
		@shift_stength ||= 1
		loci = select_loci
		@dna[loci] = ((rand > 0.5) ? (@dna[loci] + shift) : (@dna[loci] - shift))
	end

	def select_loci
		loci = (rand * @dna.length).floor
	end

	#shift, used for defining how much to mutate a given gene, will be whatever 
	#@config[:shift_strength] is set to if set to a Fixnum or Float.
	#It can be set to be "variable x" where x is the factor which rand is multiplied by
	#in variable mode each mutation will be different
	#if integer_shift is the mutation_type then a rounding will be aplied
	def shift
		return @shift_stength if ["Float", "Fixnum"].include? @shift_stength.class.inspect
		if @shift_stength.include? "variable"
			variance = @shift_stength.sub("variable","").strip.to_f
			@shift_stength = (rand * variance)
			@shift_stength = @shift_stength.round if @mutate_type.to_s=~/integer/
			return @shift_stength
		end	
	end



end
