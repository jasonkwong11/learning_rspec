class Zombie
  attr_accessor :name, :brains, :alive, :hungry

  def initialize
    @name = "Ash"
    @brains = 0
    @alive = false
  end

  def hungry?
    true
  end
end