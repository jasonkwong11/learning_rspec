#this is your shared example:

shared_examples_for 'the undead' do
  it 'does not have a pulse' do
    subject.pulse.should == false
    #subject refers to the implicit subject
    #..either zombie or vampire
  end
end

#...or make subject explicit so its clearer
shared_examples_for 'the undead' do
  it 'does not have a pulse' do
    undead.pulse.should == false
    #undead is let(:undead) in zombie_spec3
  end
end
