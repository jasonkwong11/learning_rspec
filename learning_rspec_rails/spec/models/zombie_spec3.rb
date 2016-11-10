#LEVEL 4: HOOKS AND TAGS


describe Zombie do
  let(:zombie) {Zombie.new}

  it 'is hungry' do
    zombie.hungry! 
    zombie.should be_hungry
  end

  it 'craves brains' do
    zombie.hungry!
    zombie.should be_craving_brains
  end
end 

#in the above zombie.hungry! is repeated. so dry it using a before block:

describe Zombie do
  let(:zombie) {Zombie.new}
  before { zombie.hungry!} #now this runs before each example

  it 'is hungry' do
    zombie.should be_hungry
  end

  it 'craves brains' do
    zombie.should be_craving_brains
  end
end

##You can also have it run...
#before each example (same as above)
before(:each)

#once before all
before(:all)

#after each
after(:each)

#after all
after(:all)

#another example with context
describe Zombie do
  let(:zombie) {Zombie.new}
  before { zombie.hungry! } #will execute even with examples deeply nested within context

  it 'craves brains' do
    zombie.should be_craving_brains
  end

  context 'with a veggie preference' do
    before { zombie.vegetarian = true } #available to all examples within this context
    it 'still craves brains' do
      zombie.hungry!
 #     zombie.vegetarian = true
    end

    it 'craves vegan brains' do
      zombie.hungry!
 #     zombie.vegetarian = true
    end
  end

end


###======= SHARED EXAMPLES =======


describe Zombie do
  it 'should not have a pulse' do
    zombie = Zombie.new
    zombie.pulse.should == false
  end
end

#this is in vampire_spec.rb
describe Vampire do 
  it 'should not have a pulse' do
    vampire = Vampire.new
    vampie.pulse.should == false
  end
end


#you can extract the same behavior (from above ^^)into a shared
#example you can use in both specs:
#see support/shared_example_for_undead.rb

describe Zombie do
  it_behaves_like 'the undead'
  let(:undead) { Zombie.new }
end

describe Vampire do
  it_behaves_like 'the undead'
end


##You can also rewrite the zombie example like so:
describe Zombie do
  it_behaves_like 'the undead', Zombie.new
end

###======= Meta data and Filters =======
#can tag our describe, context, it blocks so it only runs specific parts of our specs
#focus: true, and vegan: true ...see below... also put add it to spec_helper
describe Zombie do
  context 'when hungry' do
    it 'wants brains'
    context 'with a veggie preference', focus: true do
      it 'still craves brains', slow: true #slow tag lets you filter the slow tests, or skip it in the config for spec_helper

      it 'prefers vegan brains', vegan: true
    end
  end
end















