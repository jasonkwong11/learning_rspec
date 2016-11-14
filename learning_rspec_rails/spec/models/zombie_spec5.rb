##=== LEVEL 6 Custom Matchers =======

#in app/models/zombie.rb

class Zombie < ActiveRecord::Base
  validates :name, presence: true
end

#here's an example of a test for the
#validation above

describe Zombie do 
  it 'validates presence of name' do
    zombie = Zombie.new(name: nil)
    zombie.valid?
    zombie.errors.should have_key(:name)
#have_key is like 'include', but for hashes
#we might need this functionality a lot
#so we should create a custom matcher for it
  end
end

#the custom matcher should look something
#like: 

describe Zombie do
  it 'validates presence of name' do
    zombie = Zombie.new(name: nil)
    zombie.should validate_presence_of_name
    #validate_presence_of_name is custom matcher
  end
end

#so we create the custom matcher in the
#spec support folder:
#spec/support/validate_presence_of_name.rb


module ValidatePresenceOfName
  class Matcher
    def matches?(model)
      model.valid?
      model.errors.has_key?(:name)
      #^ same as our example
      #should return true or false
      #if false, expectation should fail
    end
  end

  def validate_presence_of_name
    Matcher.new
    #instantiate method we made above
  end
end

#configure Rspec to include this custom matcher
Rspec.configure do |config|
  config.include ValidatePresenceOfName, type: :model
#matcher available only to model specs (type: :model)
end

#good, the problem is we can't use this
#matcher for anything other than the 
#name attribute. We want it to be usable
#for any attribute. So we give our custom
#matcher a
#parameter so we can assign any attribute 
#to it.... like so:
describe Zombie do
  it 'validates presence of name' do
    zombie = Zombie.new(name: nil)
    zombie.should validate_presence_of(:name)
  end
end

###so lets fix our custom matcher:

module ValidatePresenceOf
  class Matcher
    def initialize(attribute)
      @attribute = attribute
    end

    def matches?(model)
      model.valid?
      model.errors.has_key?(@attribute)
   end
  end

  def validate_presence_of(attribute)
    Matcher.new(attribute)
    #instantiate method we made above
  end
end

#But what if someone removes the validation
#and this fails? Like below:

class Zombie < ActiveRecord::Base
  #validates :name, presence: true
end

# we get a failure because we need
# a failure message
#so inside of our matches? method, we're
#going to save that model in an instance
#variable, so we can use it's name in the
#failure message

module ValidatePresenceOf
  class Matcher

    def matches?(model)
      @model = model
      #saved for use in messages
      model.valid?
      model.errors.has_key?(@attribute)
   end

   def failure_message
    "#{@model.class} failed to validate :#{@attribute} presence."
   end
  end
  #...

  #below is if the custom matcher
  #doesn't fail
  def negative_failure_message
    "#{@model.class} validated :#{@attribute} presence."
  end
end

#back in app/models/zombie.rb

class Zombie < ActiveRecord::Base
  validates :name, presence: { message: 'been eaten'}
  #the error message should be returned on failure
end

#you can add the message by
#by chaining it to the matcher...like so:

describe Zombie do
  it 'validates presence of name' do
    zombie = Zombie.new(name: nil)
    zombie.should validate_presence_of(:name)
      with_message('been eaten') #this error 
      #should be returned on failure
  end
end

class Matcher
  def initialize(attribute)
    @attribute = attribute
    @message = "can't be blank"
    ##^^ default failure message
  end

  def matches?(model)
    @model = model
    @model.valid?
    errors = @model.errors[@attribute]
    errors.any? {|error| error == @message}
    ##^^ collect errors and find a match
  end

#create a with_message method
  def with_message(message)
    @message = message
    #^^ override failure message and return self
    self
  end
end


#... spec should look like this:
describe Zombie do
  it 'validates presence of name' do
    zombie = Zombie.new(name: nil)
    zombie.should validate_presence_of(:name)
      with_message('been eaten')
  end
end

## ^^ found in the shoulda gem
##other ways to CHAIN METHODS (similar to above):
it { should validate_presence_of(:name).with_message('oh noes')}
it { should ensure_inclusion_of(:age).in_range(18..25)}
it { should have_many(:weapons).dependent(:destroy)}
it { should have_many(:weapons).class_name(OneHandedWeapon)}
## ^ single line chaining

it 'has many Tweets' do
  should have_many(:tweets)
    dependent(:destroy)
    class_name(Tweet)
end

###RSPEC RESOURCES:
#
# Dave chelimsky's blog
# Ryan Bates' screencasts
# the factory girl github has a great getting started guide
# peepcode rspec screencasts




