#-------------------------------------------------------------------------------
#  Bug Bite
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:BUGBITE) do
  @vector.set(@scene.getRealVector(@targetIndex, @targetIsPlayer))
  @scene.wait(16, true)
  # set up animation
  factor = @targetSprite.zoom_x
  cx, cy = @targetSprite.getCenter(true)
  fp = {}
  dx = []
  dy = []
  da = []
  for j in 0...12
    fp["s#{j}"] = Sprite.new(@viewport)
    fp["s#{j}"].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb008")
    fp["s#{j}"].src_rect.set(32*rand(2),0,32,32)
    fp["s#{j}"].ox = fp["s#{j}"].src_rect.width/2
    fp["s#{j}"].oy = fp["s#{j}"].src_rect.height/2
    r = 32*factor
    fp["s#{j}"].x = cx - r + rand(r*2)
    fp["s#{j}"].y = cy - r + rand(r*2)
    fp["s#{j}"].z = @targetSprite.z + 1
    fp["s#{j}"].visible = false
  end
  for j in 0...32
    fp[j.to_s] = Sprite.new(@viewport)
    fp[j.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb008_2")
    fp[j.to_s].ox = fp[j.to_s].bitmap.width/2
    fp[j.to_s].oy = fp[j.to_s].bitmap.height/2
    r = 32*factor
    x = cx - r + rand(r*2)
    y = cy - r + rand(r)
    fp[j.to_s].x = x
    fp[j.to_s].y = y
    fp[j.to_s].z = @targetSprite.z
    fp[j.to_s].visible = false
    fp[j.to_s].angle = rand(360)
    ox = (x < cx ? x-rand(24*factor)-24*factor : x+rand(24*factor)+24*factor)
    oy = y - rand(24*factor) - 24*factor
    dx.push(ox)
    dy.push(oy)
    a = (x < cx ? rand(6)+1 : -rand(6)-1)
    da.push(a)
  end
  # play animation
  for i in 0...64
    for j in 0...32
      next if j>i
      fp[j.to_s].visible = true
      if ((fp[j.to_s].x - dx[j])*0.2).abs < 1
        fp[j.to_s].y += 4
        fp[j.to_s].opacity -= 16
      else
        fp[j.to_s].x -= (fp[j.to_s].x - dx[j])*0.2
        fp[j.to_s].y -= (fp[j.to_s].y - dy[j])*0.2
      end
      fp[j.to_s].angle += da[j]*8
    end
    for j in 0...12
      next if j>(i/4)
      fp["s#{j}"].visible = true
      fp["s#{j}"].opacity -= 32
      fp["s#{j}"].zoom_x += 0.02
      fp["s#{j}"].zoom_y += 0.02
      fp["s#{j}"].angle += 8
    end
    @targetSprite.zoom_y = factor + 0.32 if i%4 == 0 && i < 48
    @targetSprite.zoom_y -= 0.08 if @targetSprite.zoom_y > factor
    pbSEPlay("EBDX/Anim/bug1",80) if i%4==0 && i < 48
    @scene.wait
  end
  @vector.reset if !@multiHit
  pbDisposeSpriteHash(fp)
end
