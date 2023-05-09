#===============================================================================
#  Common Animation: CONFUSION
#===============================================================================
EliteBattle.defineCommonAnimation(:CONFUSION) do
  #-----------------------------------------------------------------------------
  #  configure variables
  @scene.wait(16, true) if @scene.afterAnim
  fp = {}; k = -1
  factor = @targetSprite.zoom_x
  reversed = []; cx, cy = @targetSprite.getCenter(true)
  #-----------------------------------------------------------------------------
  #  set up sprites
  for j in 0...8
    fp[j.to_s] = Sprite.new(@viewport)
    fp[j.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/ebConfused")
    fp[j.to_s].ox = fp[j.to_s].bitmap.width/2
    fp[j.to_s].oy = fp[j.to_s].bitmap.height/2
    fp[j.to_s].zoom_x = factor
    fp[j.to_s].zoom_y = factor
    fp[j.to_s].opacity
    fp[j.to_s].y = cy - 32*factor
    fp[j.to_s].x = cx + 64*factor - (j%4)*32*factor
    reversed.push([false,true][j/4])
  end
  #-----------------------------------------------------------------------------
  #  play animation
  vol = 80
  for i in 0...64
    k = i if i < 16
    pbSEPlay("EBDX/Anim/confusion1",vol) if i%8 == 0
    vol -= 5 if i%8 == 0
    for j in 0...8
      reversed[j] = true if fp[j.to_s].x <= cx - 64*factor
      reversed[j] = false if fp[j.to_s].x >= cx + 64*factor
      fp[j.to_s].z = reversed[j] ? @targetSprite.z - 1 : @targetSprite.z + 1
      fp[j.to_s].y = cy - 48*factor - k*2*factor - (reversed[j] ? 4*factor : 0)
      fp[j.to_s].x -= reversed[j] ? -4*factor : 4*factor
      fp[j.to_s].opacity += 16 if i < 16
      fp[j.to_s].opacity -= 16 if i >= 48
    end
    @scene.wait(1,true)
  end
  #-----------------------------------------------------------------------------
  #  dispose sprites
  pbDisposeSpriteHash(fp)
  #-----------------------------------------------------------------------------
end
