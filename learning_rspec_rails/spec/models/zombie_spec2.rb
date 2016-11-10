##Level 3, DRY Specs: organizing your examples, shortcuts to write more readable code

require 'spec_helper'

describe Zombie do

  it 'responds to name' do
    zombie = Zombie.new
    zombie.should respond_to(:name)
  end

## ^^^ YOU CAN WRITE THE ABOVE DRYER LIKE SO:

  it 'responds to name' do
    subject.should respond_to(:name)
    #^^ subject === Zombie.new
    #only works using describe with a class (like Zombie)
  end

 ## ^^^ you can write the above even DRYER like so:
 
  it 'responds to name' do
    should respond_to(:name)
  end

## ^^ can write the above using curly braces:

  it 'responds to name' { should respond_to(:name) }  

## ^^ EVEN MORE DRY!!:

  it { should respond_to(:name) }


### === its =====

  it { subject.name.should == 'Ash'}

## ^^ you can also write the above as :
  its(:name) { should == 'Ash' }

##other examples:
  its(:weapons) { should include(weapon) }
  its(:brain) { should be_nil }
  its('tweets.size') {should == 2}
end


# === NESTING EXAMPLES ====  


describe Zombie do
  it 'craves brains when hungry'
  it 'with a veggie preference still craves brains when hungry'
  it 'with a veggie preference prefers vegan brains when hungry'

# you can refactor the above^^ like so:

  it 'craves brains when hungry'

  describe 'with a veggie preference' do
    it 'still craves brains when hungry'
    it 'prefers vegan brains when hungry'
  end

## ^^ even dryer:

  describe 'when hungry' do
  it 'craves brains'
    describe 'with a veggie preference' do
      it 'still craves brains'
      it 'prefers vegan brains'
    end
  end


end



# === CONTEXT ====  (context instead of describe)

describe Zombie do 
  context 'when hungry' do
    it 'craves brains'
    context 'with a veggie preference' do
      it 'still craves brains'
      it 'still prefers vegan brains'
    end
  end
end


#if you need to have a different object use the let keyword



describe Zombie do
  context 'with a veggie preference' do
    subject {Zombie.new(vegetarian: true, weapons: [axe])}
    let(:axe) {Weapon.new(name: 'axe')}

    its(:weapons){should include(axe)}

    it 'can use its axe' do 
      subject.swing(axe).should == true
    end
  end
end

##^^ it might be unclear what subject is in the above:


describe Zombie do
  context 'with a veggie preference' do
    let(:zombie) {Zombie.new(vegetarian: true, weapons: [axe])}
    let(:axe) {Weapon.new(name: 'axe')}

    subject { zombie }

    its(:weapons){should include(axe)}

    it 'can use its axe' do 
      zombie.swing(axe).should == true
    end
  end

###here's a newer syntax
  context 'with a veggie preference' do
    subject(:zombie) {Zombie.new(vegetarian: true, weapons: [axe])}
    let(:axe) {Weapon.new(name: 'axe')}
  end
end


# === LET'S REFACTOR THIS: ====  

describe Zombie do 

  it 'has no name' do
    @zombie = Zombie.create
    @zombie.name.should be_nil?
  end

  it 'craves brains' do
    @zombie = Zombie.create
    @zombie.should be_craving_brains
  end

  it 'should not be hungry after eating brains' do
    @zombie = Zombie.create
    @zombie.hungry.should be_true
    @zombie.eat(:brains)
    @zombie.hungry.should be_false
  end

end

# === INTO THIS: ====  

describe Zombie do
  let(:zombie) {Zombie.create}
  subject { zombie }

  its(:name) {should be_nil?}

  it {should be_craving_brains}

  it 'should not be hungry after eating brains' do
    expect { zombie.eat(:brains)}.to change {
      zombie.hungry
    }.from(true).to(false)
  end

end






