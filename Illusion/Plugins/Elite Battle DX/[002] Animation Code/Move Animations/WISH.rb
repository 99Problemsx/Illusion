#-------------------------------------------------------------------------------
#  WISH
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:WISH) do
  if @hitNum == 1
    EliteBattle.playMoveAnimation(:RECOVER, @scene, @userIndex, @targetIndex)
  elsif @hitNum == 0
    EliteBattle.playMoveAnimation(:WISH_CAST, @scene, @userIndex, @targetIndex)
  end
end

EliteBattle.defineMoveAnimation(:WISH_CAST) do
  @vector.set(@scene.getRealVector(@userIndex, @userIsPlayer))
  fp = {}
  # set up animation
  @scene.wait(5,true)
  factor = @userSprite.zoom_x
  cx, cy = @userSprite.getCenter(true)
  dx = []
  dy = []
  fp = {}
  t = 35
  fp["bg"] = Sprite.new(@viewport)
  fp["bg"].bitmap = Bitmap.new(@viewport.width,@viewport.height)
  fp["bg"].bitmap.fill_rect(0,0,fp["bg"].bitmap.width,fp["bg"].bitmap.height,Color.black)
  fp["bg"].opacity = 0
  16.times do
    fp["bg"].opacity += 12
    @scene.wait(1,true)
  end
  for j in 0...t
    fp[j.to_s] = Sprite.new(@viewport)
    fp[j.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb619")
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

  pbSEPlay("Anim/Wish",80)
  for i in 0...2*t
    for j in 0...t
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
  16.times do
    fp["bg"].opacity -= 20
    @scene.wait(1,true)
  end
  @vector.reset if !@multiHit
  pbDisposeSpriteHash(fp)
end
