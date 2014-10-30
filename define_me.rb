require 'forwardable'
require 'rake'
require 'ostruct'

require './lib/common.rb'

module ObjectExtensions
	def println(arg)
		print "#{arg}\n"
	end
end

module StringExtensions

	def method_missing(m, *args, &block)
		super unless m == :def

		$definition_recorder[self]
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

class Value
	def initialize(val)
		@value = val
	end
end

class Definition
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
		@is_a = definition
	end

	def method_missing(m, *args, &block)
		self.class.send(:define_method, m, *args, &block)
	end

	def	env_set?(var, &block)
		ENV[var] and Value.new(ENV[var]).instance_eval &block
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

	def define(name, &block)
		d = Definition.as(name)
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
		"#{@object} #{@fact}"
	end
end

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

	def to_str
		self.to_s
	end
end

$definition_recorder = DefinitionsRecorder.new
$fact_recorder = FactRecorder.new