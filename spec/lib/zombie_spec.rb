require "spec_helper"
require "zombie"


describe Zombie do

  it "is named Ash" do
    zombie = Zombie.new
    expect zombie.name == 'Ash'
  end

  it "has no brains" do
    zombie = Zombie.new
    expect zombie.brains < 1
  end

  it "should not be alive" do
    zombie = Zombie.new
    expect zombie.alive == false
  end

  it 'is hungry' do
    zombie = Zombie.new
    zombie.should be_hungry
    #be_hungry calls the hungry? method on zombie
  end

  #how to make pending: 
 # it "is a pending test"

 # xit "is also pending" do
 # end

end




