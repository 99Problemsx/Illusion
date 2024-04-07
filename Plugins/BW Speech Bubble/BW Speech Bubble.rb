#-------------------------------------------------------------------------------
# BW Speech Bubbles for v21
# Updated by NoNonever
#-------------------------------------------------------------------------------
# To use, call pbCallBub(type, eventID)
#
# Where type is either 1 or 2:
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
end

module MessageConfig
  BUBBLETEXTBASE = Color.new(248, 248, 248)
  BUBBLETEXTSHADOW = Color.new(72, 80, 88)
end

#-------------------------------------------------------------------------------
# Function modifiers
#-------------------------------------------------------------------------------

class Window_AdvancedTextPokemon
  def text=(value)
<<<<<<< HEAD
    if !nil_or_empty?(value) && $game_temp.speechbubble_bubble && $game_temp.speechbubble_bubble > 0
      event = pbMapInterpreter&.get_character($game_temp.speechbubble_talking)
      if $game_temp.speechbubble_bubble == 1 && event
        $game_temp.speechbubble_bubble = 0
        resizeToFit2(value,400,100)
        @x = event.screen_x
        @y = event.screen_y - (32 + @height)
            
        if @y>(Graphics.height-@height-2)
          @y = (Graphics.height-@height)
        elsif @y<2
          @y=2
        end
        if @x > Graphics.width - @width - 2
          @x = event.screen_x-@width
        elsif @x<2
          @x=2
=======
    if !value.nil? && value != "" && $game_temp.speechbubble_bubble && $game_temp.speechbubble_bubble > 0
      if $game_temp.speechbubble_bubble == 1
        $game_temp.speechbubble_bubble = 0
        resizeToFit2(value, 400, 100)
        @x = $game_map.events[$game_temp.speechbubble_talking].screen_x
        @y = $game_map.events[$game_temp.speechbubble_talking].screen_y - (32 + @height)

        if @y > (Graphics.height - @height - 2)
          @y = (Graphics.height - @height)
        elsif @y < 2
          @y = 2
        end
        if @x > (Graphics.width - @width - 2)
          @x = ($game_map.events[$game_temp.speechbubble_talking].screen_x - @width)
        elsif @x < 2
          @x = 2
>>>>>>> 0265b0792466933921b2f7605abf3c722cd206d2
        end
      else
        $game_temp.speechbubble_bubble = 0
      end
    end
    setText(value)
  end
end

def pbRepositionMessageWindow(msgwindow, linecount=2)
  msgwindow.height = (32 * linecount) + msgwindow.borderY
  msgwindow.y = Graphics.height - msgwindow.height
  if $game_temp && $game_temp.in_battle && !$scene.respond_to?("update_basic")
    msgwindow.y = 0
  elsif $game_system && $game_system.respond_to?("message_position")
    case $game_system.message_position
    when 0  # up
      msgwindow.y = 0
    when 1  # middle
      msgwindow.y = (Graphics.height / 2) - (msgwindow.height / 2)
    when 2
      if $game_temp.speechbubble_bubble == 1
        msgwindow.setSkin("Graphics/windowskins/frlgtextskin")
        msgwindow.height = 100
        msgwindow.width = 400
      elsif $game_temp.speechbubble_bubble == 2
        msgwindow.setSkin("Graphics/windowskins/frlgtextskin")
        msgwindow.height = 102
        msgwindow.width = Graphics.width
        if $game_player.direction == 8
          $game_temp.speechbubble_vp = Viewport.new(0, 0, Graphics.width, 280)
          msgwindow.y = 6
        else
          $game_temp.speechbubble_vp = Viewport.new(0, 6 + msgwindow.height, Graphics.width, 280)
          msgwindow.y = (Graphics.height - msgwindow.height) - 6
          msgwindow.y = 6 if $game_temp.speechbubble_outofrange == true
        end
      else
        msgwindow.height = 102
        msgwindow.y = Graphics.height - msgwindow.height - 6
      end
    end
  end
  if $game_system && $game_system.respond_to?("message_frame") && ($game_system.message_frame != 0)
    msgwindow.opacity = 0
  end
  return unless $game_message
  case $game_message.background
  when 1  # dim
    msgwindow.opacity = 0
  when 2  # transparent
    msgwindow.opacity = 0
  end
end

def pbCreateMessageWindow(viewport = nil, skin = nil)
  arrow = nil
<<<<<<< HEAD
  event = pbMapInterpreter&.get_character($game_temp.speechbubble_talking)
  if $game_temp.speechbubble_bubble==2 && event != nil # Message window set to floating bubble.
    if $game_player.direction==8 # Player facing up, message window top.
=======
  if $game_temp.speechbubble_bubble == 2 && !$game_map.events[$game_temp.speechbubble_talking].nil? # Message window set to floating bubble.
    if $game_player.direction == 8 # Player facing up, message window top.
>>>>>>> 0265b0792466933921b2f7605abf3c722cd206d2
      $game_temp.speechbubble_vp = Viewport.new(0, 104, Graphics.width, 280)
      $game_temp.speechbubble_vp.z = 999_999
      arrow = Sprite.new($game_temp.speechbubble_vp)
<<<<<<< HEAD
      arrow.x = event.screen_x - Graphics.width
      arrow.y = event.screen_y - Graphics.height - 136
      arrow.z = 999999
      arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow4")
      arrow.zoom_x = 2
      arrow.zoom_y = 2
      if arrow.x<-230
        arrow.x = event.screen_x
        arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow3")
=======
      arrow.x = $game_map.events[$game_temp.speechbubble_talking].screen_x - Graphics.width
      arrow.y = ($game_map.events[$game_temp.speechbubble_talking].screen_y - Graphics.height) - 136
      arrow.z = 999_999
      arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/", "Arrow4")
      arrow.zoom_x = 2
      arrow.zoom_y = 2
      if arrow.x < -230
        arrow.x = $game_map.events[$game_temp.speechbubble_talking].screen_x
        arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/", "Arrow3")
>>>>>>> 0265b0792466933921b2f7605abf3c722cd206d2
      end
    elsif event # Player facing left, down, right, message window bottom.
      $game_temp.speechbubble_vp = Viewport.new(0, 0, Graphics.width, 280)
      $game_temp.speechbubble_vp.z = 999_999
      arrow = Sprite.new($game_temp.speechbubble_vp)
<<<<<<< HEAD
      arrow.x = event.screen_x
      arrow.y = event.screen_y
      arrow.z = 999999
      arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow1")
      if arrow.y>=Graphics.height-120 # Change arrow direction.
        $game_temp.speechbubble_outofrange=true
        $game_temp.speechbubble_vp.rect.y+=104
        arrow.x = event.screen_x - Graphics.width
        arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow4")
        arrow.y = (event.screen_y - Graphics.height) - 136
        if arrow.x<-250
          arrow.x = event.screen_x
          arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow3")
        end
        if arrow.x>=256
          arrow.x-=15# = event.screen_x-Graphics.width
          arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/","Arrow3")
=======
      arrow.x = $game_map.events[$game_temp.speechbubble_talking].screen_x
      arrow.y = $game_map.events[$game_temp.speechbubble_talking].screen_y
      arrow.z = 999_999
      arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/", "Arrow1")
      if arrow.y >= Graphics.height - 120 # Change arrow direction.
        $game_temp.speechbubble_outofrange = true
        $game_temp.speechbubble_vp.rect.y += 104
        arrow.x = $game_map.events[$game_temp.speechbubble_talking].screen_x - Graphics.width
        arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/", "Arrow4")
        arrow.y = ($game_map.events[$game_temp.speechbubble_talking].screen_y - Graphics.height) - 136
        if arrow.x < -250
          arrow.x = $game_map.events[$game_temp.speechbubble_talking].screen_x
          arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/", "Arrow3")
        end
        if arrow.x >= 256
          arrow.x -= 15 # = $game_map.events[$game_temp.speechbubble_talking].screen_x-Graphics.width
          arrow.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/", "Arrow3")
>>>>>>> 0265b0792466933921b2f7605abf3c722cd206d2
        end
      else
        $game_temp.speechbubble_outofrange = false
      end
      arrow.zoom_x = 2
      arrow.zoom_y = 2
    end
  end
  $game_temp.speechbubble_arrow = arrow
  msgwindow = Window_AdvancedTextPokemon.new("")
  if viewport
    msgwindow.viewport = viewport
  else
    msgwindow.z = 99_999
  end
  msgwindow.visible = true
  msgwindow.letterbyletter = true
  msgwindow.back_opacity = MessageConfig::WINDOW_OPACITY
  pbBottomLeftLines(msgwindow, 2)
  $game_temp.message_window_showing = true if $game_temp
  $game_message.visible = true if $game_message
  skin = MessageConfig.pbGetSpeechFrame if !skin
  msgwindow.setSkin(skin)
  return msgwindow
end

def pbDisposeMessageWindow(msgwindow)
  $game_temp.message_window_showing = false if $game_temp
  $game_message.visible = false if $game_message
  msgwindow.dispose
  $game_temp.speechbubble_arrow.dispose if $game_temp.speechbubble_arrow
  $game_temp.speechbubble_vp.dispose if $game_temp.speechbubble_vp
end

<<<<<<< HEAD
def pbCallBub(status=0,value=0)
  $game_temp.speechbubble_talking = value
  $game_temp.speechbubble_bubble = status
end
=======
def pbCallBub(status=0, value=0)
  $game_temp.speechbubble_talking = get_character(value).id
  $game_temp.speechbubble_bubble = status
end
>>>>>>> 0265b0792466933921b2f7605abf3c722cd206d2
