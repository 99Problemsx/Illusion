#===============================================================================
# This class creates a gif somewhere on the screen without disrupting gameplay - PotatoCant
# If you credited me you are awesome!
#===============================================================================

class GameplayGif
  # Name of the gif to play, How many frames (default 30, half a second), x pos, y pos (default is top right), wait (default false, wether it waits for the next message box to close, only useful if played right before one)
  def initialize(name, frames = 30, x = 0, y = 0, wait = false) 
    @sprite = Sprite.new
    @bitmap = AnimatedBitmap.new("Graphics/Pictures/#{name}")  #Location can be changed for better customization
    @sprite.bitmap = @bitmap.bitmap
    # If x is "center", position the sprite in the center of the screen
    if x == "center"
      @sprite.x = (Graphics.width - @sprite.bitmap.width) / 2
    else
      @sprite.y = y
    end
    # Handling "center" for y position, and "save" for 60px above the center (I use this during the save to add an animation simular to gen 5)
    if y == "center"
      @sprite.y = (Graphics.height - @sprite.bitmap.height) / 2
    elsif y == "save"  # Create more elsifs to add more saved spots (suggested over adding each one in the actually event script)
      @sprite.y = (Graphics.height - @sprite.bitmap.height) / 2 - 50 # Center screen but 50 pixels above to be above the player
    else
      @sprite.y = y
    end

    # Example using "center" instead of a number
    # pbShowgif("test",120,"center","center",false)  this would put the "test.gif" into the center of the screen for 120 frames

    @sprite.z = 200 # overtop most other sprites
    @timer = frames
    @wait = wait   # If wait is true, set frames to = 1, since the animation will play till the next message box closes
    @message_waiting = false
  end

  def update
    return if disposed?

    # Ensure $game_message is not nil before checking busy?
    if @wait && $game_message && $game_message.busy?
      @message_waiting = true
      return
    end

    # If we were waiting for the message to close and it has, proceed with disposing the GIF
    if @message_waiting && (!$game_message || !$game_message.busy?)
      @message_waiting = false
      dispose
      return
    end

    # Normal update process
    @bitmap.update
    @sprite.bitmap = @bitmap.bitmap
    @timer -= 1
    dispose if @timer <= 0
  end

  def disposed?
    @sprite.nil? || @sprite.disposed?
  end

  def dispose
    return if disposed?
    @sprite.dispose
    @sprite = nil
  end
end

# Extend the main game loop
class Scene_Map
  alias update_show_gif update
  def update
    update_show_gif
    @show_gif&.update
    @show_gif = nil if @show_gif&.disposed?
  end
end

# the function
def pbShowgif(name, frames = 30, x = 0, y = 0, wait = false)
  $scene.instance_variable_set(:@show_gif, GameplayGif.new(name, frames, x, y, wait))
end

# Examples
# pbShowgif("banana")                        Shows a banana for all defaults, half a second, top right, does not wait for a message box to be closed
# pbShowgif("banana",1,0,0,true)             All defaults but waits till a message box is closed
# pbShowgif("banana",60,"center","100",ture) Shows a banana for 60 frames after a message box is closed in the center horizontally, at the y cordinate of 100