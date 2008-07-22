#Family Tree is a tool for observing the history of a Genetic Algorithm
#When itialized with an Individual with a parents method which returns 
#an array of two Individuals a Tree of breeding events can be calculated
class FamilyTree

	def initialize individual
		@individual = individual
	end

	def make_tree
		@tree = []
		indivs = [@individual] 	#This is the job stack 
		print "Generating Family Tree"
		until indivs.uniq == ["no_data"]
			print "."
			gen = []							#The current layer of the family tree
			next_gen = []					#defines the jobs for next loop
			indivs.each do |ind|
				gen << ind					#put current individual into current layer of tree
				unless ind == "no_data"
					#set the parents of individual to be processed next pass
					#unless there are no parents in which case TWO placeholders stored.
					next_gen << ind.parents unless ind.parents.nil? 			
					next_gen << ["no_data","no_data"] if ind.parents.nil?
				else
					next_gen << ["no_data","no_data"]
					#if there is no individual then there will be no parents
				end
			end
			@tree.push gen #add current layer to the tree
			indivs = next_gen.flatten #add the next jobs to the stack
		end
		puts "done"
	end


	def puts_tree
		puts "tree"
		c = 0
		for level in @tree
			c+=1
			puts level.size
			o = []
			level.each do |memb|
				o << "\{#{memb.name}, #{memb.fitness}\}" unless memb == "no_data"
				o << "\{#{memb}\}" if memb == "no_data"
			end
			puts "gen: #{c}\t #{o.join(",")}"
		end
	end

	def pp_tree
		gap = "\t"
		n = 5
		if n == 4
			js = [7,3,1,0]
			jg = [0,7,3,1]
		elsif n == 5
			js = [15,7,3,1,0]
			jg = [0,15,7,3,1]
		end
		#n defines how many passes to make, while js and jg define number of spaces
		n.times do |i| 
			gen = @tree[i]
			o = []			#will contrain the current line of the tree to write
			gen.each do |memb|
				o << "\{#{memb.name},#{memb.dob ? memb.dob : "orig"} #{memb.fitness}\}#{memb.mutant? ? "<-M" : ""}" unless memb == "no_data"
				o << "\{#{memb}\}" if memb == "no_data"
			end

			
			sp = "--------"
			msg, s, g, s_n, sp_n, g_n = "", "", "", "", "", ""
			js[i].times {s << gap}
			jg[i].times {g << gap}

			#s is the space at the start of each line, g is the size of gap between items on the line
			#s_n is the space for the next line, g_p is the gap spacing for the next line.  Next line knowledge
			#is needed in order to draw the branches on the tree


			#add the down lines 
			unless jg[i] == 0
				msg << "#{s}"
				gen.size.times do
					msg << "\t|#{g}"
				end
			end

			#add information under down lines
			msg << "\n#{s}#{o.join(g) }"

			#add horizonital lines for the next row 
			unless i == n-1
				js[i+1].times {s_n << gap}
				(jg[i+1]+1).times {sp_n << sp}
				(jg[i+1]).times {g_n << gap}
				msg << "\n#{s_n}"
				gen.size.times do 
				msg << "\t#{sp_n}#{g_n}"
				end
			end

			puts msg
		end
		
	end

end
