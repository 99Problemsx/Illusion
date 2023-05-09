#===============================================================================
#  Common Animation: PARALYSIS
#===============================================================================
EliteBattle.defineCommonAnimation(:PARALYSIS) do
  #-----------------------------------------------------------------------------
  #  configure variables
  @scene.wait(16, true) if @scene.afterAnim
  fp = {}; k = -1
  factor = @targetSprite.zoom_x
  #-----------------------------------------------------------------------------
  #  set up sprites
  for i in 0...12
    fp[i.to_s] = Sprite.new(@viewport)
    fp[i.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb064_3")
    fp[i.to_s].ox = fp[i.to_s].bitmap.width/2
    fp[i.to_s].oy = fp[i.to_s].bitmap.height/2
    fp[i.to_s].opacity = 0
    fp[i.to_s].z = @targetIsPlayer ? 29 : 19
  end
  #-----------------------------------------------------------------------------
  #  play animation
  pbSEPlay("EBDX/Anim/electric1")
  for i in 0...32
    k *= -1 if i%16 == 0
    for n in 0...12
      next if n>(i/2)
      if fp[n.to_s].opacity == 0 && fp[n.to_s].tone.gray == 0
        r2 = rand(4)
        fp[n.to_s].zoom_x = [0.2,0.25,0.5,0.75][r2]
        fp[n.to_s].zoom_y = [0.2,0.25,0.5,0.75][r2]
        cx, cy = @targetSprite.getCenter(true)
        x, y = randCircleCord(32*factor)
        fp[n.to_s].x = cx - 32*factor*@targetSprite.zoom_x + x*@targetSprite.zoom_x
        fp[n.to_s].y = cy - 32*factor*@targetSprite.zoom_y + y*@targetSprite.zoom_y
        fp[n.to_s].angle = -Math.atan(1.0*(fp[n.to_s].y-cy)/(fp[n.to_s].x-cx))*(180.0/Math::PI) + rand(2)*180 + rand(90)
      end
      fp[n.to_s].opacity += 155 if i < 27
      fp[n.to_s].angle += 180 if i%2 == 0
      fp[n.to_s].opacity -= 51 if i >= 27
    end
    @targetSprite.tone.all -= 14*k
    @targetSprite.still
    @scene.wait(1,true)
  end
  #-----------------------------------------------------------------------------
  #  dispose sprites
  pbDisposeSpriteHash(fp)
  #-----------------------------------------------------------------------------
end
