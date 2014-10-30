require './definitions.rb'

describe 'Java'.def do
	it 'is configured' do		
		'Java'.def.should have_JAVA_HOME_set
		'Java'.def.should be_installed		
	end
end