#-------------------------------------------------------------------------------
#  GUST
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:GUST) do
  itself = (@userIndex==@targetIndex)
  # set up animation
  fp = {}
  rndx = []
  rndy = []
  numElements = 5
  for i in 0...numElements
    fp[i.to_s] = Sprite.new(@viewport)
    fp[i.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb637")
    fp[i.to_s].src_rect.set(0,128*rand(3),64,128)
    fp[i.to_s].ox = 26
    fp[i.to_s].oy = 101
    fp[i.to_s].opacity = 0
    fp[i.to_s].z = (@targetIsPlayer ? 29 : 19)
    rndx.push(rand(64))
    rndy.push(rand(64))
  end
  shake = 2
  # start animation
  @sprites["battlebg"].defocus
  for i in 0...80
    ax, ay = @userSprite.getAnchor
    cx, cy = @targetSprite.getCenter(true)
    for j in 0...numElements
      if fp[j.to_s].opacity == 0 && fp[j.to_s].tone.gray == 0
        fp[j.to_s].zoom_x = @userSprite.zoom_x
        fp[j.to_s].zoom_y = @userSprite.zoom_y
        fp[j.to_s].x = ax
        fp[j.to_s].y = ay + 50*@userSprite.zoom_y
      end
      next if j>(i/4)
      x2 = cx - 32*@targetSprite.zoom_x + rndx[j]*@targetSprite.zoom_x
      y2 = cy - 32*@targetSprite.zoom_y + rndy[j]*@targetSprite.zoom_y + 50*@targetSprite.zoom_y
      x0 = fp[j.to_s].x
      y0 = fp[j.to_s].y
      fp[j.to_s].x += (x2 - x0)*0.1
      fp[j.to_s].y += (y2 - y0)*0.1
      fp[j.to_s].zoom_x -= (fp[j.to_s].zoom_x - @targetSprite.zoom_x)*0.1
      fp[j.to_s].zoom_y -= (fp[j.to_s].zoom_y - @targetSprite.zoom_y)*0.1
      fp[j.to_s].src_rect.x += 64 if i%4==0
      fp[j.to_s].src_rect.x = 0 if fp[j.to_s].src_rect.x >= fp[j.to_s].bitmap.width
      if (x2 - x0)*0.1 < 1 && (y2 - y0)*0.1 < 1
        fp[j.to_s].opacity -= 8
        fp[j.to_s].tone.gray += 8
        fp[j.to_s].zoom_x -= 0.02
        fp[j.to_s].zoom_y += 0.04
      else
        fp[j.to_s].opacity += 3
      end
    end
    pbSEPlay("Anim/Wind8",80) if i%24==0 && i <= 60
    if i >= 50
      @targetSprite.ox += shake
      shake = -2 if @targetSprite.ox > @targetSprite.bitmap.width/2 + 2
      shake = 2 if @targetSprite.ox < @targetSprite.bitmap.width/2 - 2
      @targetSprite.still
    end
    @vector.set(EliteBattle.get_vector(:DUAL)) if i == 24
    @vector.inc = 0.1 if i == 24
    @scene.wait(1,true)
  end
  20.times do
    @targetSprite.ox += shake
    shake = -2 if @targetSprite.ox > @targetSprite.bitmap.width/2 + 2
    shake = 2 if @targetSprite.ox < @targetSprite.bitmap.width/2 - 2
    @targetSprite.still
    @scene.wait(1,true)
  end
  @sprites["battlebg"].focus
  @targetSprite.ox = @targetSprite.bitmap.width/2
  @vector.reset if !@multiHit
  @vector.inc = 0.2
  pbDisposeSpriteHash(fp)
end
