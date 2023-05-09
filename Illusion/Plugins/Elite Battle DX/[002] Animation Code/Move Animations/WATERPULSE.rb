#-------------------------------------------------------------------------------
#  WATERPULSE
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:WATERPULSE) do
 vector = @scene.getRealVector(@targetIndex, @targetIsPlayer)
  vector2 = @scene.getRealVector(@userIndex, @userIsPlayer)
  factor = @userIsPlayer ? 2 : 1
  # set up animation
  fp = {}; rndx = []; rndy = []; dx = []; dy = []; idxZoom = []
  fp["bg"] = Sprite.new(@viewport)
  fp["bg"].bitmap = Bitmap.new(@viewport.width,@viewport.height)
  fp["bg"].bitmap.fill_rect(0,0,fp["bg"].bitmap.width,fp["bg"].bitmap.height,Color.new(42,78,131))
  fp["bg"].opacity = 0
  for i in 0...72
    fp[i.to_s] = Sprite.new(@viewport)
	if i%6 == 0
		fp[i.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb612_6")
	else
		fp[i.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb000")
	end
    fp[i.to_s].ox = fp[i.to_s].bitmap.width/2
    fp[i.to_s].oy = fp[i.to_s].bitmap.height/2
	fp[i.to_s].zoom_x = 1.0
	fp[i.to_s].zoom_y = 1.0
    fp[i.to_s].opacity = 0
    fp[i.to_s].z = 19
	idxZoom[i] = 0
	rndx.push(rand(1))
    rndy.push(rand(1))
  end
  shake = 4
  # start animation
  @sprites["battlebg"].defocus
  @vector.set(vector2)
  16.times do
    fp["bg"].opacity += 10
    @scene.wait(1,true)
  end
  for i in 0...96
	pbSEPlay("Anim/Bubble2") if i == 2
    ax, ay = @userSprite.getAnchor
    cx, cy = @targetSprite.getCenter(true)
    for j in 0...72
	  pbSEPlay("Anim/Bubble1") if j == 0 && i%10 == 0
      if fp[j.to_s].opacity == 0 && fp[j.to_s].tone.gray == 0
        dx[j] = ax - 8*@userSprite.zoom_x*0.5 + rndx[j]*@userSprite.zoom_x*0.5
        dy[j] = ay - 8*@userSprite.zoom_y*0.5 + rndy[j]*@userSprite.zoom_y*0.5
        fp[j.to_s].x = dx[j]
        fp[j.to_s].y = dy[j]
      end
      next if j>(i)
      x0 = dx[j]
      y0 = dy[j]
      x2 = cx - 8*@targetSprite.zoom_x*0.5 + rndx[j]*@targetSprite.zoom_x*0.5
      y2 = cy - 8*@targetSprite.zoom_y*0.5 + rndy[j]*@targetSprite.zoom_y*0.5
	  if idxZoom[j] < 3
		fp[j.to_s].zoom_x *= 0.85
		fp[j.to_s].zoom_y *= 0.85
	  else
	  	fp[j.to_s].zoom_x *= 1.15
		fp[j.to_s].zoom_y *= 1.15
	  end
	  idxZoom[j] += 1
	  idxZoom[j] = 0 if idxZoom[j] == 6
      fp[j.to_s].x += (x2 - x0)*0.07
      fp[j.to_s].y += (y2 - y0)*0.07
      fp[j.to_s].opacity += 51
      fp[j.to_s].angle = -Math.atan(1.0*(y2-y0)/(x2-x0))*180/Math::PI + (rand(4)==0 ? 180 : 0)
      nextx = fp[j.to_s].x# + (x2 - x0)*0.1
      nexty = fp[j.to_s].y# + (y2 - y0)*0.1
      if !@targetIsPlayer
        fp[j.to_s].z = @targetSprite.z - 1 if nextx > cx && nexty < cy
      else
        fp[j.to_s].z = @targetSprite.z + 1 if nextx < cx && nexty > cy
      end
	  if i > 85
		fp[j.to_s].opacity -= 100
	  end
    end
    if i >= 64
      @targetSprite.ox += shake
      shake = -4 if @targetSprite.ox > @targetSprite.bitmap.width/2 + 2
      shake = 4 if @targetSprite.ox < @targetSprite.bitmap.width/2 - 2
      @targetSprite.still
    end
    pbSEPlay("Anim/Bubble1") if i == 64
    fp["bg"].update
    @vector.set(vector) if i == 32
    @vector.inc = 0.1 if i == 32
    @scene.wait(1,true)
  end
  @targetSprite.ox = @targetSprite.bitmap.width/2
  16.times do
    fp["bg"].opacity -= 20
    @scene.wait(1,true)
  end
  @sprites["battlebg"].focus
  @vector.reset if !@multiHit
  @vector.inc = 0.2
  pbDisposeSpriteHash(fp)
end
