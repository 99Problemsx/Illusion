#-------------------------------------------------------------------------------
#  HEALORDER
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:HEALORDER) do
  # configure animation
  @vector.set(@scene.getRealVector(@userIndex, @userIsPlayer))
  @scene.wait(16,true)
  factor = @userSprite.zoom_x
  cx, cy = @userSprite.getCenter(true)
  dx = []
  dy = []
  fp = {}
  numElements = 60
  for j in 0...numElements
    fp[j.to_s] = Sprite.new(@viewport)
    fp[j.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb010_4")
    fp[j.to_s].ox = fp[j.to_s].bitmap.width/2
    fp[j.to_s].oy = fp[j.to_s].bitmap.height/2
    r = 45*factor
    x, y = randCircleCord(r)
    x = cx - r + x
    y = cy - r + y
    fp[j.to_s].x = cx
    fp[j.to_s].y = cy
    fp[j.to_s].z = @userSprite.z
    fp[j.to_s].visible = false
    fp[j.to_s].angle = rand(360)
    z = [0.5,1,0.75][rand(3)]
    fp[j.to_s].zoom_x = z
    fp[j.to_s].zoom_y = z
    dx.push(x)
    dy.push(y)
  end
  # target coloring
  @targetSprite.color = Color.new(105,164,103,0)
  # start animation
  pbSEPlay("EBDX/Anim/ground1",80)
  for i in 0...48
    for j in 0...numElements
      next if j>(i*2)
      fp[j.to_s].visible = true
      if ((fp[j.to_s].x - dx[j])*0.1).abs < 1
        fp[j.to_s].opacity -= 32
      else
        fp[j.to_s].x -= (fp[j.to_s].x - dx[j])*0.1
        fp[j.to_s].y -= (fp[j.to_s].y - dy[j])*0.1
      end
    end
	if i < 24
      @targetSprite.color.alpha += 10
    else
      @targetSprite.color.alpha -= 10
    end
	@targetSprite.still
    @targetSprite.anim = true
    @scene.wait
  end
  @vector.reset if !@multiHit
  pbDisposeSpriteHash(fp)
end
