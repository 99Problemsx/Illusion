#===============================================================================
#  Common Animation: STATUP
#===============================================================================
EliteBattle.defineCommonAnimation(:STATUP) do
  #-----------------------------------------------------------------------------
  #  configure variables
  @scene.wait(16, true) if @scene.afterAnim
  pt = {}; rndx = []; rndy = []; tone = []; timer = []; speed = []
  endy = @targetSprite.y - @targetSprite.height*(@targetIsPlayer ? 1.5 : 1)
  #-----------------------------------------------------------------------------
  #  set up sprites
  for i in 0...64
    s = rand(2)
    y = rand(64) + 1
    c = [Color.new(238,83,17),Color.new(236,112,19),Color.new(242,134,36)][rand(3)]
    pt[i.to_s] = Sprite.new(@viewport)
    pt[i.to_s].bitmap = Bitmap.new(14,14)
    pt[i.to_s].bitmap.bmp_circle(c)
    pt[i.to_s].center!
    width = (96/@targetSprite.width*0.5).to_i
    pt[i.to_s].x = @targetSprite.x + rand((64 + width)*@targetSprite.zoom_x - 16)*(s==0 ? 1 : -1)
    pt[i.to_s].y = @targetSprite.y
    pt[i.to_s].z = @targetSprite.z + (rand(2)==0 ? 1 : -1)
    r = rand(4)
    pt[i.to_s].zoom_x = @targetSprite.zoom_x*[1,0.9,0.95,0.85][r]*0.84
    pt[i.to_s].zoom_y = @targetSprite.zoom_y*[1,0.9,0.95,0.85][r]*0.84
    pt[i.to_s].opacity = 0
    pt[i.to_s].tone = Tone.new(128,128,128)
    tone.push(128)
    rndx.push(pt[i.to_s].x + rand(32)*(s==0 ? 1 : -1))
    rndy.push(endy - y*@targetSprite.zoom_y)
    timer.push(0)
    speed.push((rand(50)+1)*0.002)
  end
  #-----------------------------------------------------------------------------
  #  play animation
  pbSEPlay("Anim/increase")
  for i in 0...64
    for j in 0...64
      next if j > (i*2)
      timer[j] += 1
      pt[j.to_s].x += (rndx[j] - pt[j.to_s].x)*speed[j]
      pt[j.to_s].y -= (pt[j.to_s].y - rndy[j])*speed[j]
      tone[j] -= 8 if tone[j] > 0
      pt[j.to_s].tone.all = tone[j]
      pt[j.to_s].angle += 4
      if timer[j] > 8
        pt[j.to_s].opacity -= 8
        pt[j.to_s].zoom_x -= 0.02*@targetSprite.zoom_x if pt[j.to_s].zoom_x > 0
        pt[j.to_s].zoom_y -= 0.02*@targetSprite.zoom_y if pt[j.to_s].zoom_y > 0
      else
        pt[j.to_s].opacity += 25 if pt[j.to_s].opacity < 200
        pt[j.to_s].zoom_x += 0.025*@targetSprite.zoom_x
        pt[j.to_s].zoom_y += 0.025*@targetSprite.zoom_y
      end
    end
    @scene.wait(1, true)
  end
  #-----------------------------------------------------------------------------
  #  dispose sprites
  pbDisposeSpriteHash(pt)
  #-----------------------------------------------------------------------------
end
