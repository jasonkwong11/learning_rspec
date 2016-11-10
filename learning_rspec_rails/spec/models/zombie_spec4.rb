##MOCKING AND STUBBING

#in /app/models/zombie.rb:

class Zombie < ActiveRecord::Base
  has_one :weapon

  def decapitate
    weapon.slice(self, :head)
    self.status = "dead again"
  end

  def slice(args*)
    #complex stuff to slice off stuff
  end
end
#when we test the decapitate method, but
#we don't want that call to weapon to be executed
#so we need stubb or mock, but which is which?
#STUB: for replacing a method with code that returns
# a specified result
#MOCK: a stub with an expection attached to it
#(a stub with expectations that the method gets called)

describe Zombie  do
  let(:zombie) { Zombie.create }

  context "#decapitate" do
#test that the slice function gets called,
# so you need a mock:
    it "calls weapon.slice" do
      zombie.weapon.should_receive(:slice)
      #this stubs the method and 
      #sets an expectation that slice is called
      #inside our example
      zombie.decapitate #decapitate will try to call slice and
        #fulfill the expectation and pass the test
        #if we didnt' call decapitate, test would fail
        #because slice isn't being called
    end

#testing that the status gets set
    it "sets status to dead again" do
      zombie.weapon.stub(:slice)
      zombie.decapitate
      zombie.status.should == "dead again"
    end
  end
end



## ===== MOCKING WITH PARAM
#in /app/models/zombie.rb:

class Zombie < ActiveRecord::Base
  def geolocate
    Zoogle.graveyard_locator(self.graveyard)
  end
end

## in /spec/models/zombie_spec.rb
##we need to make sure when geolocate is called,
## it calls to the graveyard_locator:

it "calls Zoogle.graveyard_locator" do
  #mock with param
  Zoogle.should_receive(:graveyard_locator).with(zombie.graveyard)
  #allows us to test that not only the method gets
  #called, but called with this specific parameter
  #...then call geolocate method to fulfill expectation
  zombie.geolocate
end


# ==== now say we tweak the geolocate method so it
#now returns a hash. and we use the hash to create
# a string (STUB AND RETURN)

class Zombie < ActiveRecord::Base
  def geolocate
    Zoogle.graveyard_locator(self.graveyard)
    '#{loc[:latitude]}, #{loc{:longitude}}'
  end
end

it "calls Zoogle.graveyard_locator" do
  #mock with param
  Zoogle.should_receive(:graveyard_locator).with(zombie.graveyard)
    .and_return({latitude: 2, longitude: 3})
  #allows us to test that not only the method gets
  #called, but called with this specific parameter
  # AND RETURN VALUE
  #...then call geolocate method to fulfill expectation
  zombie.geolocate
end

#now we to make sure the right string
#is constructed and returned

class Zombie < ActiveRecord::Base
  def geolocate
    Zoogle.graveyard_locator(self.graveyard)
    '#{loc[:latitude]}, #{loc{:longitude}}'
  end
end

it "returns properly formatted lat, long" do
  Zoogle.stub(:graveyard_locator).with(zombie.graveyard)
    .and_return({latitude: 2, longitude: 3})
  zombie.geolocate.should == "2, 3"
end



### STUB OBJECT

class Zombie < ActiveRecord::Base
  def geolocate_with_object
    loc = Zoogle.graveyard_locator(self.graveyard)

#==>  should return an object:
  # def latitude
    # return 2
  # end
  # def longitude
    # return 3
  # end
    '#{loc[:latitude]}, #{loc{:longitude}}'
  end
end

## in this case, we want to create a stub/ double...
it "returns properly formatted lat, long" do
#send in a hash:
  loc = stub(latitude: 2, longitude: 3)
  #keys are going to be methods we can call on the stub
  # e.g.: we can call loc.latitude and it returns 2.... loc.longitude ==> 3
  Zoogle.stub(:graveyard_locator).returns(loc)
  ##^^ stub out graveyard_locator and make sure it returns that stub object
  zombie.geolocate_with_object.should == "2, 3"
  ##^ make sure geolocate_with_object returns string, "2, 3"
end



##STUBS IN THE WILD... WITH RAILS ACTIONMAILER

class ZombieMailer < ActionMailer::Base
  def welcome(zombie)
    mail(from: 'admin@codeschool.com', to: zombie.email,
        subject: 'Welcome Zombie!')
  end
end

## spec/mailers/zombie_mailer_spec.rb

describe ZombieMailer do
  context '#welcome' do
   # let(:zombie) {Zombie.create(email: 'ash@zombiemail.com')}
   # ^^ not good how we're creating an ActiveRecord 
   #object every time, so change it to a fake object:
    let(:zombie) { stub(email: 'ash@zombiemail.com')}
    #^^^ This is our fake zombie object
    subject {ZombieMailer.welcome(zombie)}

    its(:from) {should include('admin@codeschool.com')}
    its(:to) {should include(zombie.email)}
    its(:subject) {should == 'Welcome Zombie!'}
  end
end

## MORE STUB OPTIONS:

target.should_receive(:function).once
                                .twice
                                .exactly(3).times
                                .at_least(2).times
                                .at_most(3).times
                                .any_number_of_times
## can also specify multiple parameters:
target.should_receive(:function).with(no_args())
                                .with(any_args())
                                .with("B", anything())
                                .with(3, kind_of(Numeric))
                                .with(/zombie ash/)










