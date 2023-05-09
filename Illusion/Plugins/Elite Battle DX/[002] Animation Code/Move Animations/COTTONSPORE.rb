#-------------------------------------------------------------------------------
#  COTTONSPORE
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:COTTONSPORE) do
  # configure animation
  @vector.set(@scene.getRealVector(@targetIndex, @targetIsPlayer))
  @scene.wait(16,true)
  factor = @targetSprite.zoom_x
  cx, cy = @targetSprite.getCenter(true)
  dx = []
  dy = []
  fp = {}
  mass = 40
  for j in 0...mass
    fp[j.to_s] = Sprite.new(@viewport)
    fp[j.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb59_9")
    fp[j.to_s].ox = fp[j.to_s].bitmap.width/2
    fp[j.to_s].oy = fp[j.to_s].bitmap.height/2
    r = 40*factor
    x, y = randCircleCord(r)
    x = cx - r + x
    y = cy - r + y
    fp[j.to_s].x = cx
    fp[j.to_s].y = cx
    fp[j.to_s].z = @targetSprite.z
    fp[j.to_s].visible = false
    fp[j.to_s].angle = rand(360)
    z = [0.5,1,0.75][rand(3)]
    fp[j.to_s].zoom_x = z
    fp[j.to_s].zoom_y = z
    dx.push(x)
    dy.push(y)
  end
  # target coloring
  @targetSprite.color = Color.new(228,228,228,0)
  # start animation
  pbSEPlay("EBDX/Anim/ground1",80)
  for i in 0...48
    for j in 0...mass
      next if j>(i*2)
      fp[j.to_s].visible = true
      if ((fp[j.to_s].x - dx[j])*0.1).abs < 1
        fp[j.to_s].opacity -= 32
      else
        fp[j.to_s].x -= (fp[j.to_s].x - dx[j])*0.1
        fp[j.to_s].y -= (fp[j.to_s].y - dy[j])*0.1
      end
    end
	if i < 30
      @targetSprite.color.alpha += 10
    else
      @targetSprite.color.alpha -= 20
    end
	@targetSprite.still
    @targetSprite.anim = true
    @scene.wait
  end
  @vector.reset if !@multiHit
  pbDisposeSpriteHash(fp)
end
