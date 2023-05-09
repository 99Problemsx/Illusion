#===============================================================================
#  Common Animation: SLEEP
#===============================================================================
EliteBattle.defineCommonAnimation(:SLEEP) do
  #-----------------------------------------------------------------------------
  #  configure variables
  @scene.wait(16, true) if @scene.afterAnim
  fp = {}; r = []
  factor = @targetSprite.zoom_x
  #-----------------------------------------------------------------------------
  #  set up sprites
  for i in 0...3
    fp[i.to_s] = Sprite.new(@viewport)
    fp[i.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/ebSleep")
    fp[i.to_s].center!
    fp[i.to_s].angle = @targetIsPlayer ? 55 : 125
    fp[i.to_s].zoom_x = 0
    fp[i.to_s].zoom_y = 0
    fp[i.to_s].z = @targetIsPlayer ? 29 : 19
    fp[i.to_s].tone = Tone.new(192,192,192)
    r.push(0)
  end
  #-----------------------------------------------------------------------------
  #  play animation
  pbSEPlay("EBDX/Anim/snore",80)
  for j in 0...48
    cx, cy = @targetSprite.getCenter(true)
    for i in 0...3
      next if i > (j/12)
      fp[i.to_s].zoom_x += ((1*factor) - fp[i.to_s].zoom_x)*0.1
      fp[i.to_s].zoom_y += ((1*factor) - fp[i.to_s].zoom_y)*0.1
      a = @targetIsPlayer ? 55 : 125
      r[i] += 4*factor
      x = cx + r[i]*Math.cos(a*(Math::PI/180)) + 16*factor*(@targetIsPlayer ? 1 : -1)
      y = cy - r[i]*Math.sin(a*(Math::PI/180)) - 32*factor
      fp[i.to_s].x = x; fp[i.to_s].y = y
      fp[i.to_s].opacity -= 16 if r[i] >= 64
      fp[i.to_s].tone.all -= 16 if fp[i.to_s].tone.all > 0
      fp[i.to_s].angle += @targetIsPlayer ? - 1 : 1
    end
    @scene.wait(1,true)
  end
  #-----------------------------------------------------------------------------
  #  dispose sprites
  pbDisposeSpriteHash(fp)
  #-----------------------------------------------------------------------------
end
