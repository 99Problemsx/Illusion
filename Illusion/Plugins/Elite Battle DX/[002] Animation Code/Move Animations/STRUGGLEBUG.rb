#-------------------------------------------------------------------------------
#  Struggle Bug
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:STRUGGLEBUG) do
  # configure animation
  @vector.set(@scene.getRealVector(@userIndex, @userIsPlayer))
  @scene.wait(16,true)
  factor = @userSprite.zoom_x
  cx, cy = @userSprite.getCenter(true)
  dx = []
  dy = []
  fp = {}
  for j in 0...24
    fp[j.to_s] = Sprite.new(@viewport)
    fp[j.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb010")
    fp[j.to_s].ox = fp[j.to_s].bitmap.width/2
    fp[j.to_s].oy = fp[j.to_s].bitmap.height/2
    r = 64*factor
    x, y = randCircleCord(r)
    x = cx - r + x
    y = cy - r + y
    fp[j.to_s].x = cx
    fp[j.to_s].y = cx
    fp[j.to_s].z = @userSprite.z
    fp[j.to_s].visible = false
    fp[j.to_s].angle = rand(360)
    z = [0.5,1,0.75][rand(3)]
    fp[j.to_s].zoom_x = z
    fp[j.to_s].zoom_y = z
    dx.push(x)
    dy.push(y)
  end
  # start animation
  pbSEPlay("EBDX/Anim/ground1",80)
  for i in 0...48
    for j in 0...24
      next if j>(i*2)
      fp[j.to_s].visible = true
      if ((fp[j.to_s].x - dx[j])*0.1).abs < 1
        fp[j.to_s].opacity -= 32
      else
        fp[j.to_s].x -= (fp[j.to_s].x - dx[j])*0.1
        fp[j.to_s].y -= (fp[j.to_s].y - dy[j])*0.1
      end
    end
    @scene.wait
  end
  @vector.set(@scene.getRealVector(@targetIndex, @targetIsPlayer))
  @scene.wait(16,true)
  factor = @targetSprite.zoom_x
  cx, cy = @targetSprite.getCenter(true)
  for j in 0...12
    fp["s#{j}"] = Sprite.new(@viewport)
    fp["s#{j}"].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb244_2")
    fp["s#{j}"].ox = fp["s#{j}"].bitmap.width/2
    fp["s#{j}"].oy = fp["s#{j}"].bitmap.height/2
    r = 32*factor
    fp["s#{j}"].x = cx - r + rand(r*2)
    fp["s#{j}"].y = cy - r + rand(r*2)
    fp["s#{j}"].z = @targetSprite.z + 1
    fp["s#{j}"].visible = false
    fp["s#{j}"].tone = Tone.new(255,255,255)
    fp["s#{j}"].angle = rand(360)
  end
  # anim2
  for i in 0...32
    for j in 0...12
      next if j>(i*2)
      fp["s#{j}"].visible = true
      fp["s#{j}"].opacity -= 32
      fp["s#{j}"].zoom_x += 0.02
      fp["s#{j}"].zoom_y += 0.02
      fp["s#{j}"].angle += 8
      fp["s#{j}"].tone.red -= 32
      fp["s#{j}"].tone.green -= 32
      fp["s#{j}"].tone.blue -= 32
    end
    @targetSprite.still
    pbSEPlay("EBDX/Anim/normal2",80) if i%4==0 && i < 16
    @scene.wait
  end
  @vector.reset if !@multiHit
  pbDisposeSpriteHash(fp)
end
