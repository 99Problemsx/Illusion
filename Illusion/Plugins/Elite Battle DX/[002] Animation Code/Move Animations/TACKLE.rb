#-------------------------------------------------------------------------------
#  Tackle
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:TACKLE) do | args |
  withvector, shake = *args; withvector = true if withvector.nil?; shake = false if shake.nil?
  factor = @targetSprite.zoom_x
  # set up animation
  fp = {}
  rndx = []
  rndy = []
  for i in 0...12
    fp[i.to_s] = Sprite.new(@viewport)
    fp[i.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb303_2")
    fp[i.to_s].ox = 10
    fp[i.to_s].oy = 10
    fp[i.to_s].opacity = 0
    fp[i.to_s].z = 50
    r = rand(3)
    fp[i.to_s].zoom_x = (@targetSprite.zoom_x)*(r==0 ? 1 : 0.5)
    fp[i.to_s].zoom_y = (@targetSprite.zoom_y)*(r==0 ? 1 : 0.5)
    fp[i.to_s].tone = Tone.new(60,60,60)
    rndx.push(rand(128))
    rndy.push(rand(64))
  end
  @vector.set(@scene.getRealVector(@targetIndex, @targetIsPlayer)) if withvector
  @scene.wait(20,true) if withvector
  factor = @targetSprite.zoom_y
  pbSEPlay("EBDX/Anim/normal1",80)
  frame = Sprite.new(@viewport)
  frame.z = 50
  frame.bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb303")
  frame.src_rect.set(0,0,64,64)
  frame.ox = 32
  frame.oy = 32
  frame.zoom_x = 0.5*factor
  frame.zoom_y = 0.5*factor
  frame.x, frame.y = @targetSprite.getCenter(true)
  frame.opacity = 0
  frame.tone = Tone.new(255,255,255)
  frame.y -= 32*@targetSprite.zoom_y
  # start animation
  for i in 1..30
    if i < 8 && shake
      x=(i/4 < 1) ? 2 : -2
      @scene.moveEntireScene(0, x*2, true, true)
    end
    if i.between?(1,5)
      @targetSprite.still
      @targetSprite.zoom_y-=0.05*factor
      @targetSprite.tone.all-=12.8
      frame.zoom_x += 0.1*factor
      frame.zoom_y += 0.1*factor
      frame.opacity += 51
    end
    frame.tone = Tone.new(0,0,0) if i == 6
    if i.between?(6,10)
      @targetSprite.still
      @targetSprite.zoom_y+=0.05*factor
      @targetSprite.tone.all+=12.8
      frame.angle += 2
    end
    frame.src_rect.x = 64 if i == 10
    if i >= 10
      frame.opacity -= 25.5
      frame.zoom_x += 0.1*factor
      frame.zoom_y += 0.1*factor
      frame.angle += 2
    end
    for j in 0...12
      cx = frame.x; cy = frame.y
      if fp[j.to_s].opacity == 0 && fp[j.to_s].visible
        fp[j.to_s].x = cx
        fp[j.to_s].y = cy
      end
      x2 = cx - 64*@targetSprite.zoom_x + rndx[j]*@targetSprite.zoom_x
      y2 = cy - 64*@targetSprite.zoom_y + rndy[j]*@targetSprite.zoom_y
      x0 = fp[j.to_s].x
      y0 = fp[j.to_s].y
      fp[j.to_s].x += (x2 - x0)*0.2
      fp[j.to_s].y += (y2 - y0)*0.2
      fp[j.to_s].zoom_x += 0.01
      fp[j.to_s].zoom_y += 0.01
      if i < 20
        fp[j.to_s].tone.red -= 6; fp[j.to_s].tone.blue -= 6; fp[j.to_s].tone.green -= 6
      end
      if (x2 - x0)*0.2 < 1 && (y2 - y0)*0.2 < 1
        fp[j.to_s].opacity -= 51
      else
        fp[j.to_s].opacity += 51
      end
      fp[j.to_s].visible = false if fp[j.to_s].opacity <= 0
    end
    @scene.wait
  end
  frame.dispose
  pbDisposeSpriteHash(fp)
  @vector.reset if !@multiHit
end
#-------------------------------------------------------------------------------
#  Substitute
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:SUBSTITUTE) do
  pbSEPlay("Anim/Substitute")
  @scene.setSubstitute(@userIndex, true)
end
