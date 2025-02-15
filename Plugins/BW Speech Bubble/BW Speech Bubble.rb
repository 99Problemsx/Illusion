#-------------------------------------------------------------------------------
# BW Speech Bubbles for v21
# Updated by NoNonever
#-------------------------------------------------------------------------------
# To use, call pbCallBub(type, eventID)
#
# Where type is either 1 oder 2:
# 1 - floating bubble
# 2 - speech bubble with arrow
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Class modifiers
#-------------------------------------------------------------------------------

class Game_Temp
  attr_accessor :speechbubble_bubble
  attr_accessor :speechbubble_vp
  attr_accessor :speechbubble_arrow
  attr_accessor :speechbubble_outofrange
  attr_accessor :speechbubble_talking
  attr_accessor :speechbubble_active
end

module MessageConfig
  BUBBLETEXTBASE  = Color.new(248,248,248)
  BUBBLETEXTSHADOW= Color.new(72,80,88)
end

#-------------------------------------------------------------------------------
# Function modifiers
#-------------------------------------------------------------------------------

class Window_AdvancedTextPokemon
  def text=(value)
    if value != nil && value != "" && $game_temp.speechbubble_bubble && $game_temp.speechbubble_bubble > 0
      if $game_temp.speechbubble_bubble == 1
        $game_temp.speechbubble_bubble = 0
        resizeToFit2(value,400,100)
        if $game_temp.speechbubble_talking == $game_player
          @x = $game_player.screen_x
          @y = $game_player.screen_y - (32 + @height)
        else
          @x = $game_map.events[$game_temp.speechbubble_talking.id].screen_x
          @y = $game_map.events[$game_temp.speechbubble_talking.id].screen_y - (32 + @height)
        end

        if @y>(Graphics.height-@height-2)
          @y = (Graphics.height-@height)
        elsif @y<2
          @y=2
        end
        if @x>(Graphics.width-@width-2)
          @x = ($game_map.events[$game_temp.speechbubble_talking.id].screen_x-@width)
        elsif @x<2
          @x=2
        end
      else
        $game_temp.speechbubble_bubble = 0
      end
    end
    setText(value)
  end
end 

def pbRepositionMessageWindow(msgwindow, linecount=2)
  msgwindow.height=32*linecount+msgwindow.borderY
  msgwindow.y=(Graphics.height)-(msgwindow.height)
  if $game_temp && $game_temp.in_battle && !$scene.respond_to?("update_basic")
    msgwindow.y=0
  elsif $game_system && $game_system.respond_to?("message_position")
    case $game_system.message_position
    when 0  # up
      msgwindow.y=0
    when 1  # middle
      msgwindow.y=(Graphics.height/2)-(msgwindow.height/2)
    when 2 # bottom
      if $game_temp.speechbubble_bubble==1
        msgwindow.setSkin("Graphics/windowskins/frlgtextskin")
        msgwindow.height = 100
        msgwindow.width = 400
      elsif $game_temp.speechbubble_bubble==2
        msgwindow.setSkin("Graphics/windowskins/frlgtextskin")
        msgwindow.height = 102
        msgwindow.width = Graphics.width
        if $game_temp.speechbubble_talking == $game_player
          if $game_player.direction == 8
            $game_temp.speechbubble_vp = Viewport.new(0, 0, Graphics.width, 280)
            msgwindow.y = 6
          else
            $game_temp.speechbubble_vp = Viewport.new(0, 6 + msgwindow.height, Graphics.width, 280)
            msgwindow.y = (Graphics.height - msgwindow.height) - 6
            if $game_temp.speechbubble_outofrange
              msgwindow.y = 6
            end
          end
        else
          if $game_player.direction == 8
            $game_temp.speechbubble_vp = Viewport.new(0, 0, Graphics.width, 280)
            msgwindow.y = 6
          else
            $game_temp.speechbubble_vp = Viewport.new(0, 6 + msgwindow.height, Graphics.width, 280)
            msgwindow.y = (Graphics.height - msgwindow.height) - 6
            if $game_temp.speechbubble_outofrange
              msgwindow.y = 6
            end
          end
        end
      else
        msgwindow.height = 102
        msgwindow.y = Graphics.height - msgwindow.height - 6
      end
    end
  end
  if $game_system && $game_system.respond_to?("message_frame")
    if $game_system.message_frame != 0
      msgwindow.opacity = 0
    end
  end
  if $game_message
    case $game_message.background
    when 1  # dim
      msgwindow.opacity=0
    when 2  # transparent
      msgwindow.opacity=0
    end
  end
end
 
def pbCreateMessageWindow(viewport = nil, skin = nil)
  arrow = nil
  if $game_temp.speechbubble_bubble==2 && ($game_temp.speechbubble_talking || $game_temp.speechbubble_talking == $game_player) != nil # Message window set to floating bubble.
    if $game_temp.speechbubble_talking == $game_player # Player is talking
      if $game_player.direction==8 # Player facing up, message window top.
        $game_temp.speechbubble_vp = Viewport.new(0, 104, Graphics.width, 280)
        $game_temp.speechbubble_vp.z = 999999
        arrow = Sprite.new($game_temp.speechbubble_vp)
        arrow.x = $game_player.screen_x - Graphics.width
        arrow.y = ($game_player.screen_y - Graphics.height) - 136
        arrow.z = 999999
        arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow4")
        arrow.zoom_x = 2
        arrow.zoom_y = 2
        if arrow.x < -230
          arrow.x = $game_player.screen_x
          arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow3")
        end
      else # Player facing left, down, right, message window bottom.
        $game_temp.speechbubble_vp = Viewport.new(0, 0, Graphics.width, 280)
        $game_temp.speechbubble_vp.z = 999999
        arrow = Sprite.new($game_temp.speechbubble_vp)
        arrow.x = $game_player.screen_x
        arrow.y = $game_player.screen_y
        arrow.z = 999999
        arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow1")
        if arrow.y >= Graphics.height - 120 # Change arrow direction.
          $game_temp.speechbubble_outofrange = true
          $game_temp.speechbubble_vp.rect.y += 104
          arrow.x = $game_player.screen_x - Graphics.width
          arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow4")
          arrow.y = ($game_player.screen_y - Graphics.height) - 136
          if arrow.x < -250
            arrow.x = $game_player.screen_x
            arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow3")
          end
          if arrow.x >= 256
            arrow.x -= 15
            arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow3")
          end
        else
          $game_temp.speechbubble_outofrange = false
        end
        arrow.zoom_x = 2
        arrow.zoom_y = 2
      end
    else # Event is talking
      if $game_player.direction==8 # Player facing up, message window top.
        $game_temp.speechbubble_vp = Viewport.new(0, 104, Graphics.width, 280)
        $game_temp.speechbubble_vp.z = 999999
        arrow = Sprite.new($game_temp.speechbubble_vp)
        arrow.x = $game_map.events[$game_temp.speechbubble_talking.id].screen_x - Graphics.width
        arrow.y = ($game_map.events[$game_temp.speechbubble_talking.id].screen_y - Graphics.height) - 136
        arrow.z = 999999
        arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow4")
        arrow.zoom_x = 2
        arrow.zoom_y = 2
        if arrow.x < -230
          arrow.x = $game_map.events[$game_temp.speechbubble_talking.id].screen_x
          arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow3")
        end
      else # Player facing left, down, right, message window bottom.
        $game_temp.speechbubble_vp = Viewport.new(0, 0, Graphics.width, 280)
        $game_temp.speechbubble_vp.z = 999999
        arrow = Sprite.new($game_temp.speechbubble_vp)
        arrow.x = $game_map.events[$game_temp.speechbubble_talking.id].screen_x
        arrow.y = $game_map.events[$game_temp.speechbubble_talking.id].screen_y
        arrow.z = 999999
        arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow1")
        if arrow.y >= Graphics.height - 120 # Change arrow direction.
          $game_temp.speechbubble_outofrange = true
          $game_temp.speechbubble_vp.rect.y += 104
          arrow.x = $game_map.events[$game_temp.speechbubble_talking.id].screen_x - Graphics.width
          arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow4")
          arrow.y = ($game_map.events[$game_temp.speechbubble_talking.id].screen_y - Graphics.height) - 136
          if arrow.x < -250
            arrow.x = $game_map.events[$game_temp.speechbubble_talking.id].screen_x
            arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow3")
          end
          if arrow.x >= 256
            arrow.x -= 15
            arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow3")
          end
        else
          $game_temp.speechbubble_outofrange = false
        end
        arrow.zoom_x = 2
        arrow.zoom_y = 2
      end
    end
  end
  $game_temp.speechbubble_arrow = arrow
  $game_temp.speechbubble_active = true # Mark speech bubble as active
  msgwindow = Window_AdvancedTextPokemon.new("")
  if !viewport
    msgwindow.z = 99999
  else
    msgwindow.viewport = viewport
  end
  msgwindow.visible = true
  msgwindow.letterbyletter = true
  msgwindow.back_opacity = MessageConfig::WINDOW_OPACITY
  pbBottomLeftLines(msgwindow, 2)
  $game_temp.message_window_showing = true if $game_temp
  $game_message.visible = true if $game_message
  skin = MessageConfig.pbGetSpeechFrame() if !skin
  msgwindow.setSkin(skin)
  return msgwindow
end

def pbDisposeMessageWindow(msgwindow)
  $game_temp.message_window_showing = false if $game_temp
  $game_message.visible = false if $game_message
  msgwindow.dispose
  $game_temp.speechbubble_arrow.dispose if $game_temp.speechbubble_arrow
  $game_temp.speechbubble_vp.dispose if $game_temp.speechbubble_vp
  $game_temp.speechbubble_active = false # Mark speech bubble as inactive
end

def pbCallBub(status = 0, value = 0)
  if value == -1
    $game_temp.speechbubble_talking = $game_player
  else
    event = get_character(value)
    if event
      $game_temp.speechbubble_talking = event
    else
      $game_temp.speechbubble_talking = nil
      return
    end
  end
  $game_temp.speechbubble_bubble = status
end

#-------------------------------------------------------------------------------
# Update method to move the arrow with the player or event
#-------------------------------------------------------------------------------

class Spriteset_Map
  alias original_update update
  def update
    original_update
    update_speechbubble_arrow if $game_temp.speechbubble_active
  end

  def update_speechbubble_arrow
    return unless $game_temp.speechbubble_arrow

    if $game_temp.speechbubble_talking == $game_player
      $game_temp.speechbubble_arrow.x = $game_player.screen_x
      $game_temp.speechbubble_arrow.y = $game_player.screen_y
    elsif $game_temp.speechbubble_talking
      event = $game_temp.speechbubble_talking
      $game_temp.speechbubble_arrow.x = event.screen_x
      $game_temp.speechbubble_arrow.y = event.screen_y
    end
  end
end