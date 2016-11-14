class Vampire

end

describe Vampire do 
  it 'should not have a pulse' do
    vampire = Vampire.new
    vampire.pulse.should == false
  end
end