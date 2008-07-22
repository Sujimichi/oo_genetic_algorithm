class FamilyTree

	def initialize individual
		@individual = individual
	end

	def make_tree
		@tree = []
		indivs = [@individual]
		next_gen = ""
		print "Generating Family Tree"
		until indivs.uniq == ["no_data"]
			print "."
			gen = []
			next_gen = []
			indivs.each do |ind|

				gen << ind
				unless ind == "no_data"
					next_gen << ind.parents unless ind.parents.nil?
					next_gen << ["no_data","no_data"] if ind.parents.nil?
				else
					next_gen << ["no_data","no_data"]
				end
			end
			@tree.push gen
			indivs = next_gen.flatten
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
		
		n.times do |i| 
			gen = @tree[i]
			o = []
			gen.each do |memb|
				o << "\{#{memb.name},#{memb.dob ? memb.dob : "orig"} #{memb.fitness}\}#{memb.mutant? ? "<-M" : ""}" unless memb == "no_data"
				o << "\{#{memb}\}" if memb == "no_data"
			end
			sp = "--------"
			msg, s, g, s_n, sp_n, g_n = "", "", "", "", "", ""

			js[i].times {s << gap}
			jg[i].times {g << gap}

			unless jg[i] == 0
				msg << "#{s}"
				gen.size.times do
					msg << "\t|#{g}"
				end
			end

			msg << "\n#{s}#{o.join(g) }"

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
