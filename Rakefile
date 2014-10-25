
require 'forwardable'
require 'rake'
require 'ostruct'

class Definition < OpenStruct
	# extend OpenStruct
	attr_accessor :object

	def initialize(obj)
		@object = obj		
		@source = OpenStruct.new
	end

	def method_missing(m, *args, &block)
		@source.send(m, *args, &block)
	end

	def self.as(obj)
		Definition.new obj
	end

	def to_s
		"definition '#{@object}'"
	end
end

class DefinitionsRecorder
	include Forwardable

	def initialize
		@definitions = {}

		def_delegator :@definitions, :[], :[]
	end


	def define(d, &block)
		println "define> #{d}"

		block.call(d)
		@definitions[d.object] = d
	end



	def to_s
		"recorded definitions '#{@definitions}'"
	end

	def to_str
		self.to_s
	end
end

$definition_recorder = DefinitionsRecorder.new

class FactRecorder
	
	def initialize
		@facts = {}
	end

	def fact(f)
		println "fact_recorder> recording fact '#{f}'"
		@facts[f.object] = f
	end

	def to_s
		"recorded facts #{@facts}"
	end

	def to_str
		self.to_s
	end
end

$fact_recorder = FactRecorder.new

module ObjectExtensions
	def println(arg)
		print "#{arg}\n"
	end

	def fact(f)
		# println fact_recorder.type
		defined? $fact_recorder 
	end
end

module StringExtensions

	def method_missing(m, *args, &block)
		println "method_missing> method #{m} not found on String"

		match = m.to_s.match(/is_(\w+\?)/)
		
		method_name, _ = match.captures if match 
		if (method_name == "installed?")
			println "installed?> #{self}.is_#{method_name}"

			return Fact.is(self, method_name)
		end

		if (m == :as)
			println "as> #{self}.as" 

			return Definition.as(self)
		end
		
		super
	end 
end

class Fact
	attr_accessor :object

	def initialize(obj, fact)
		@object = obj
		@fact = fact			
	end

	def self.is(obj, fact)
		Fact.new(obj, fact)
	end

	def to_s
		"#{@object} is #{@fact}"
	end
end

class Object
	include ObjectExtensions
	include Forwardable

	def_delegator :$fact_recorder, :fact, :fact
	def_delegator :$definition_recorder, :define, :define
end


class String
	include StringExtensions
end

define 'Java'.as do | java |
	java.version = "1.7"	
end

fact 'Java'.is_installed?
# println $fact_recorder

# fact 'Cassandra'.can_be_installed?

# Rake.application.init
# Rake.application.load_rakefile
# Rake.application.invoke_task('one')

task 'one' do
	println 'task one'
	
end

task 'two' do
	println 'task two'
end

_three = task 'three', [:title] => ['two', 'two'] do |tsk, args| 
	println 'task three'
	println "called #{tsk} (#{args[:title]})"
	

	println $fact_recorder
	println $definition_recorder
end

println "#{$definition_recorder['Java'].version}"


#fact 'Java'.is_installed?

# println _three.invoke 12


