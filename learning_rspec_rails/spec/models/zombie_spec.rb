#CONFIGURATION AND MATCHERS

##CONFIGURATION
  #Run: gem install rspec, rspec --init, rails generate rspec:install

require 'spec_helper'

describe Zombie do

  it 'is invalid without a name' do
    zombie = Zombie.new
    zombie.should_not be_valid
  end

  it "has a name that matches 'Ash Clone'" do
    zombie = Zombie.new(name: "Ash Clone 1")
    zombie.name.should match(/Ash Clone \d/)
  end

  it 'includes tweets' do
    tweet1 = Tweet.new(status: "Uuuuuhhh")
    tweet2 = Tweet.new(status: "Arrrrgggg")
    zombie = Zombie.new(name: 'Ash', tweets: [tweet1, tweet2])
    zombie.tweets.should include(tweet1)
    zombie.tweets.should include(tweet2)
  end

  it 'starts with two weapons' do
    zombie = Zombie.new(name: 'Ash')
 #  zombie.weapons.count.should == 2 
 #this works but doesn't read well
#instead do this:
    zombie.should have(2).weapons
    #you can also use this with have(n)
    #you can also use this with have_at_least(n)
    #you can also use this with have_at_most(n)
  end

##EXPECT BLOCK:
  it 'changes the number of Zombies' do
    zombie = Zombie.new(name: 'Ash')
    expect { zombie.save }.to change {Zombie.count}.by(1)
  end

#you can also use by(n)
#you can also use from(n)
#you can also use to(n)

## RAISE_ERROR to raise exception

  it 'raises an error if saved without a name' do
    zombie = Zombie.new
    expect { zombie.save! }.to raise_error(
        ActiveRecord::RecordInvalid
      )
  end
  #These modifiers also work: 
  #to, not_to, to_not


#MORE MATCHERS:

#respond_to(<method_name>)
  #@zombie.should respond_to(hungry?)

#be_within(<range>).of(<expected>)
  #@width.should be_within(0.1).of(33.3)

#exist
  #@zombie.should exist

#satisfy{}
  #@zombie.should satisfy {|zombie| zombie.hungry?}

#be_kind_of(<class>)
  #@hungry_zombie.should be_kind_of(Zombie)

#be_an_instance_of(<class>)
  #@status.should be_an_instance_of(String)
end




