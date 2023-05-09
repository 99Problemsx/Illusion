#===============================================================================
#  Common Animation: ATTRACT
#===============================================================================
EliteBattle.defineCommonAnimation(:ATTRACT) do
  @vector.set(@scene.getRealVector(@userIndex, @userIsPlayer))
  fp = {}
  # set up animation
  @scene.wait(5,true)
  shake = 6
  for i in 0...12
    @userSprite.still
	pbSEPlay("Cries/#{@userSprite.species}",85) if i == 4
    if i.between?(4,12)
      @userSprite.ox += shake
      shake = -6 if @userSprite.ox > @userSprite.bitmap.width/2 + 2
      shake = 6 if @userSprite.ox < @userSprite.bitmap.width/2 - 2
    end
    @scene.wait(1,true)
  end
  #taunt
  @vector.set(@scene.getRealVector(@targetIndex, @targetIsPlayer))
  @scene.wait(16,true)
  factor = @targetSprite.zoom_x
  cx, cy = @targetSprite.getCenter(true)
  dx = []
  dy = []
  t = 2
  for j in 0..t
    fp[j.to_s] = Sprite.new(@viewport)
    fp[j.to_s].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb636_2")
    fp[j.to_s].ox = fp[j.to_s].bitmap.width/2
    fp[j.to_s].oy = fp[j.to_s].bitmap.height/2
    fp[j.to_s].x = cx + 20 if j == 0
    fp[j.to_s].x = cx - 20 if j == 1    
	fp[j.to_s].x = cx      if j == 2
    fp[j.to_s].y = cy - 40 if j < 2
    fp[j.to_s].y = cy - 10 if j == 2
    fp[j.to_s].z = @targetSprite.z
    fp[j.to_s].visible = false
    z = [0.5,1,0.75][rand(3)]
    fp[j.to_s].zoom_x = z
    fp[j.to_s].zoom_y = z
  end
  # start animation
  for i in 0...30
	pbSEPlay("Anim/Love",100) if i == 3 || i == 9 || i == 15
    for j in 0..t
      next if j>(i*2)
	  next if i <= 5 && j == 1
      fp[j.to_s].visible = true
      if i > 20
        fp[j.to_s].opacity -= 32
      else
		if fp[j.to_s].zoom <= 1.5
			fp[j.to_s].zoom += 0.1
		else
		    fp[j.to_s].opacity -= 32
		end
      end
    end
    @scene.wait
  end
  @targetSprite.ox = @targetSprite.bitmap.width/2
  @vector.reset if !@multiHit
  pbDisposeSpriteHash(fp)
end
