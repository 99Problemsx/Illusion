#-------------------------------------------------------------------------------
#  EXPLOSION
#-------------------------------------------------------------------------------
EliteBattle.defineCommonAnimation(:EXPLOSION) do
  @vector.set(@scene.getRealVector(@targetIndex, @targetIsPlayer))
  @scene.wait(7,true)
  cx, cy = @targetSprite.getCenter(true)
  dx = []
  dy = []
  factor = @targetSprite.zoom_x
  fp = {}
  for j in 0...24
    fp[j.to_s] = Sprite.new(@viewport)
	if rand(0..1)==0
		fp[j.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb010")
	else
		fp[j.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb010_2")
	end
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
  # rest of the particles
  for i in 0...48
	pbSEPlay("Anim/Explosion1",100) if i%8 == 0
    for j in 0...24
      next if j>(i*2)
      fp[j.to_s].visible = true
      if ((fp[j.to_s].x - dx[j])*0.1).abs < 1
        fp[j.to_s].opacity -= 32
      else
        fp[j.to_s].x -= (fp[j.to_s].x - dx[j])*0.1
        fp[j.to_s].y -= (fp[j.to_s].y - dy[j])*0.1
		fp[j.to_s].color.alpha += rand(-50..50)
      end
    end
	if i.between?(5,19)
		@targetSprite.tone.all-=12
	end
	if i.between?(20,34)
		@targetSprite.tone.all+=12
	end
    @scene.wait
  end
  pbDisposeSpriteHash(fp)
  @vector.reset
end