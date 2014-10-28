
require 'forwardable'
require 'rake'
require 'ostruct'

require './lib/common.rb'

class Definition
	# include Module
	def initialize(obj)
		@object = obj		
		@source = OpenStruct.new
	end

	def object
		@object
	end

	def method_missing(m, *args, &block)			
		@source.send(m, *args, &block) unless @definition.respond_to?(m) do

			@definition.send(m, *args, &block)
		end		
	end

	def self.as(obj)
		Definition.new obj
	end

	def is_a(definition)
		println "'#{@object}' is_a '#{definition}'"

		@is_a = definition
	end

	def method_missing(m, *args, &block)
		println "method #{m} not found on Definition, arg1 #{args[0]}"		
		
		println "defined method #{self.class}##{m}()"
		self.class.send(:define_method, m, *args)
	end

	def holds?
		println "#{self} holds?"

	end

	def to_s
		"definition '#{@object}'"
	end
end

class DefinitionsRecorder
	include Forwardable

	def initialize
		@definitions = Hash.new

		def_delegator :@definitions, :[], :[]
	end

	def define(d, &block)
		println "define> #{d}"
		d.instance_eval &block
		
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

	def has_fact?(f)
		@facts.has_key? f
	end

	def facts_hold?
		println "facts_hold?"

		@facts.each do |key, value|
			value.holds?
		end
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

		if (m == :as)
			println "as> #{self}.as" 

			return Definition.as(self)
		end

		methods = ["to_int", "to_path", "to_ary","to_str","to_sym","to_hash", "to_proc", "to_io","to_a", "to_s"]
		if methods.include? m.to_s
			super

			return
		end

		return Fact.is(self, m)
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

	def holds?		
		println "fact holds? '#{@object}' #{@fact}"
		definition = $definition_recorder[@object]

		println "sending '#{@fact}' to #{definition}"
		definition.send :"#{@fact}"
	end

	def to_s
		"#{@object} #{@fact}"
	end
end

class Object
	include ObjectExtensions
	include Forwardable

	def_delegator :$fact_recorder, :fact, :fact
	def_delegator :$fact_recorder, :facts_hold?, :facts_hold?
	def_delegator :$definition_recorder, :define, :define
end


class String
	include StringExtensions
end

class Ctx	
	def initialize(*args)
		@source = OpenStruct.new
		@args = args		
	end

	def method_missing(m, *args, &block)			
		@source.send(m, *args, &block) unless @definition.respond_to?(m) do

			@definition.send(m, *args, &block)
		end		
	end
end

define 'process'.as do
	can_be_launched? Proc.new{ 

		_, code = run_shell "#{@exe} nohup", '.'
		raise 'Failed to run Java' if code == 127
	}

	env_set? Proc.new{ |var, block|
		println "Accessing env var #{var}"
		println "#{var}: '#{ENV[var]}'"
		
		raise '!!! to run Java' unless ENV[var]

		println block
		# block.call
		
		println Ctx.new(ENV[var])
		Ctx.new(ENV[var]).instance_eval do
			println @args

			class A
				def initialize(dir)
					@dir = dir
				end
			end

			A.new(@args[0]).instance_eval &block
			# block.call
		end
		# Ctx.new(ENV[var]).instance_eval Proc.new{block.call} unless block
	}

end

define 'Java'.as do
	is_a 'process'
	@exe = 'java'

	is_installed? -> {
		can_be_launched?
		env_set? 'JAVA_HOME', Proc.new{
			println @dir
		}
		# env_set? 'JAVA_HOME', Proc.new{
		# 	# println "Checking if dir '#{@args[0]}' exists"

		# 	# Dir.exists? @args[0]
		# }
	}	
end

fact 'Java'.is_installed?
facts_hold?

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

task :default do
	println 'default task'
end

println $fact_recorder
println $definition_recorder
