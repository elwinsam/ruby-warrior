class Player
  def beingAttacked?
    return @warrior.health < @health
  end
  
  def play_turn(warrior)
    @warrior = warrior
    lookArray = @warrior.look
    
    action(lookArray)    
    
    if (checkForPivot)
      acted = true
    elsif (checkForCaptives)
      acted = trie
    elsif (!acted && warrior.health < 20 && !beingAttacked?)
      warrior.rest!
    else
      moveLogic
    end
    
    @health = warrior.health
  end
  
  def action(lookArray)
    space = lookArray.pop
    case space
    when "nothing"
      @warrior.walk!
    when "wall"
      @warrior.pivot!
    when "Captive"
      @warrior.rescue!
    when "Slug", "Archer"
      @warrior.fight!
    when "Wizard"
      @warrior.shoot!
    end
  end
  
  def checkForPivot
    if (@warrior.feel.wall?)
      @warrior.pivot!
      return true
    end
    
    return false
  end
  
  def checkForCaptives
    if (@warrior.feel.captive?)
      @warrior.rescue!
      return true
    elsif (@warrior.feel(:backward).captive?)
      @warrior.rescue!(:backward)
      return true
    end
    
    return false
  end
  
  def moveLogic
    if (beingAttacked? && @warrior.health < 10)
      @warrior.walk!(:backward)
    elsif (@warrior.feel.empty?)
      @warrior.walk!
    else
      @warrior.attack!
    end
    
    # BEFORE LEARNING HOW TO PIVOT
    # if (!@foundBackEndOfRoom && @warrior.feel(:backward).empty?)
    #   @foundBackEndOfRoom = false
    #   @warrior.walk!(:backward)
    #   return
    # elsif (@warrior.feel(:backward).wall?)
    #   @foundBackEndOfRoom = true
    # else
    #   if (@pivot != :backward)
    #     @warrior.pivot!(:backward)
    #     @pivot = :backward
    #   else
    #     @warrior.attack!(:backward)
    #   end
    #   return
    # end
    # 
    # if (@foundBackEndOfRoom)
    #   if (beingAttacked? && @warrior.health < 10)
    #     @warrior.walk!(:backward)
    #   elsif (@warrior.feel.empty?)
    #     @warrior.walk!
    #   else
    #     @warrior.attack!
    #   end
    # end
  end
end
