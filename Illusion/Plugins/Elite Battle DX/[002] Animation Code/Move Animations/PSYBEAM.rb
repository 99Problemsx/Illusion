#-----------------------------------------------------------------------------
#  Psybeam
#-----------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:PSYBEAM) do
  vector = @scene.getRealVector(@userIndex, @userIsPlayer)
  # set up animation
  fp = {}; rndx = []; rndy = []; dx = []; dy = []
  for i in 0...72
    fp[i.to_s] = RainbowSprite.new(@viewport)
    fp[i.to_s].setBitmap("Graphics/EBDX/Animations/Moves/eb460", 24)
    fp[i.to_s].center!
    fp[i.to_s].opacity = 0
    fp[i.to_s].z = 19
    rndx.push(rand(16)); rndy.push(rand(16))
    dx.push(0); dy.push(0)
  end
  # set vector
  @vector.set(vector)
  # start animation
  for i in 0...96
    @vector.reset if i == 12
    ax, ay = @userSprite.getAnchor
    cx, cy = @targetSprite.getCenter(true)
    for j in 0...72
      if fp[j.to_s].opacity == 0 && fp[j.to_s].tone.gray == 0
        dx[j] = ax - 8*@userSprite.zoom_x*0.5 + rndx[j]*@userSprite.zoom_x*0.5
        dy[j] = ay - 8*@userSprite.zoom_y*0.5 + rndy[j]*@userSprite.zoom_y*0.5
        fp[j.to_s].x = dx[j]
        fp[j.to_s].y = dy[j]
      end
      next if j>(i*2)
      x2 = cx - 8*@targetSprite.zoom_x*0.5 + rndx[j]*@targetSprite.zoom_x*0.5
      y2 = cy - 8*@targetSprite.zoom_y*0.5 + rndy[j]*@targetSprite.zoom_y*0.5
      x0 = dx[j]; y0 = dy[j]
      fp[j.to_s].x += (x2 - x0)*0.02
      fp[j.to_s].y += (y2 - y0)*0.02
      fp[j.to_s].zoom_x = @targetIsPlayer ? @userSprite.zoom_x : @targetSprite.zoom_x
      fp[j.to_s].zoom_y = @targetIsPlayer ? @userSprite.zoom_y : @targetSprite.zoom_y
      fp[j.to_s].opacity += 32
      fp[j.to_s].update
      nextx = fp[j.to_s].x + (x2 - x0)*0.02
      nexty = fp[j.to_s].y + (y2 - y0)*0.02
      if !@targetIsPlayer
        fp[j.to_s].z = @targetSprite.z - 1 if nextx > cx && nexty < cy
        fp[j.to_s].visible = false if nextx > cx && nexty < cy
      else
        fp[j.to_s].visible = false if nextx < cx && nexty > cy
      end
    end
    if i >= 32
      @targetSprite.tone.red -= 4 if @targetSprite.tone.red > -64
      @targetSprite.tone.green -= 9 if @targetSprite.tone.green > -144
      @targetSprite.still
    end
    pbSEPlay("EBDX/Anim/psychic1", 75) if i>6 && i%14==0
    @scene.wait(1,true)
  end
  16.times do
    @targetSprite.tone.red += 4
    @targetSprite.tone.green += 9
    @targetSprite.still
    @scene.wait(1,true)
  end
  @targetSprite.ox = @targetSprite.bitmap.width/2
  @targetSprite.tone = Tone.new(0,0,0)
  pbDisposeSpriteHash(fp)
end
