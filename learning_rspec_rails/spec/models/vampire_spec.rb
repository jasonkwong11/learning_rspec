describe Vampire do 
  it 'should not have a pulse' do
    vampire = Vampire.new
    vampie.pulse.should == false
  end
end