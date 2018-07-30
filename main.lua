display.setStatusBar( display.HiddenStatusBar )

 
 
require ("physics")
physics.start()
physics.setGravity( 0, 9.8)
physics.setVelocityIterations( 1 )
physics.setPositionIterations( 1 )
physics.setAverageCollisionPositions( true )
--physics.setDrawMode ( "hybrid" ) -- Uncomment in order to show in hybrid mode 

local effect = require("lava_filter")
graphics.defineEffect(effect)



local background = display.newImageRect("background_01.png", 384, 568 )
background.x = display.contentCenterX
background.y = display.contentCenterY


local Circle = display.newCircle(  display.contentWidth/2 + 20, 100, 20)
Circle.alpha = 0
--Circle.strokeWidth = 6
--Circle:setFillColor(228,228,228,1/255)

local ramp = display.newImageRect("rock.png", 205, 60 )
ramp.x = display.contentCenterX - 20
ramp.y = display.contentCenterY
physics.addBody( ramp, "static", borderBody, {bounce = 0} )
ramp.rotation = 45


local ramp2 = display.newImageRect("rock.png", 205, 60 )
ramp2.x = display.contentCenterX + 115
ramp2.y = display.contentHeight - 120
physics.addBody( ramp2, "static", borderBody, {bounce = 0} )
ramp2.rotation = -45

local wall2 = display.newRect(0, 0, 20, 60 )
wall2.x = display.contentCenterX - 60
wall2.y = display.contentHeight - 30
wall2.alpha = 0
physics.addBody( wall2, "static", borderBody, {bounce = 0} )

local wall1 = display.newRect(0, 0, 20, 60 )
wall1.x = display.contentCenterX + 35
wall1.y = display.contentHeight - 30
wall1.alpha = 0
physics.addBody( wall1, "static", borderBody, {bounce = 0} )

local lavagroup = display.newGroup()

local volcano = display.newImageRect("vulcano_top.png", 384, 200 )
volcano.x = display.contentCenterX
volcano.y = volcano.contentHeight/2


local volcano2 = display.newImageRect("vulcano_top.png", 384, 200 )
volcano2.x = display.contentCenterX
volcano2.y = display.contentHeight - volcano2.contentHeight/6
volcano2.rotation = 180

--The top edge
local borderTop = display.newRect( display.contentWidth/2, -4, display.contentWidth, 10 )
physics.addBody( borderTop, "static", borderBody, {bounce = 0} )
borderTop.name = "roof"
borderTop:setFillColor(255, 0, 0, 0)

--The bottom edge
local borderBottom = display.newRect( display.contentWidth/2, display.contentHeight+4, display.contentWidth, 10 )
physics.addBody( borderBottom, "static",borderBody , {bounce = 0})
borderBottom.name = "floor"
borderBottom:setFillColor(0, 255, 0, 0)

--The left edge
local borderLeft = display.newRect( -4, display.contentHeight/2, 10, display.contentHeight )
physics.addBody( borderLeft, "static", borderBody, {bounce = 0} )
borderLeft.name = "left"
borderLeft:setFillColor(0, 0, 255, 0)

--The right edge
local borderRight = display.newRect( display.contentWidth+4, display.contentHeight/2, 10, display.contentHeight )
physics.addBody( borderRight, "static", borderBody, {bounce = 0})
borderRight.name = "right"
borderRight:setFillColor(255, 0, 255, 0)




local lava = {}

local group = display.newGroup()
local iNr = 1
local adjustPlacement = 1
local lavaRotate = 0

local function spawnlava()

        local randomExposure = math.random(2, 9)/10
        local randomSize = math.random(85, 95)
        local rad = math.random(3,5)

        lava[iNr] = display.newImageRect(lavagroup, "brick_glow1.png", randomSize, randomSize )
        lava[iNr].blendMode = "add"
        lava[iNr].fill.effect = "filter.custom.glowing"
        lava[iNr].fill.effect.saturate.intensity = 0.5
        lava[iNr].fill.effect.blur.intensity = 0.3
        lava[iNr].fill.effect.exposure.exposure = randomExposure


        lava[iNr].x = Circle.x + adjustPlacement
        lava[iNr].y = Circle.y
        lava[iNr].rotation = lavaRotate

        physics.addBody( lava[iNr], {radius = rad, density = 10, friction = 0, bounce = 0 } )
        lava[iNr].isFixedRotation = false
        lava[iNr].linearDamping = 1.5
        lava[iNr].angularDamping = 4

        local function removePhysics(object)
            
            timer.performWithDelay( 5000, function() 
                physics.removeBody( object ) 
                object:removeSelf()
                object = nil
             end, 1 )
         end

        local randomExposure = math.random(12, 17)/10
        transition.to( lava[iNr].fill.effect.exposure, { delay = 500, time = 2000, exposure = randomExposure/2, onComplete = removePhysics(lava[iNr])} )
        transition.to( lava[iNr].fill.effect.blur, {time = 4500, intensity = 0.2} )
        transition.to( lava[iNr].fill.effect.saturate, {delay = 1500, time = 3000, intensity = 0.9} )


        iNr = iNr + 1
        adjustPlacement = adjustPlacement*-1
        lavaRotate = math.random(1, 360)

end     

timer.performWithDelay(60, spawnlava, 600)


local function onTouch( event )
        local t = event.target
        local phase = event.phase

        if "began" == phase then

                local parent = t.parent
                parent:insert( t )
                display.getCurrentStage():setFocus( t )

                t.isFocus = true

                t.x0 = event.x - t.x
                t.y0 = event.y - t.y

        elseif t.isFocus then

                if "moved" == phase then
                        t.x = event.x - t.x0
                        t.y = event.y - t.y0
            
                elseif "ended" == phase or "cancelled" == phase then
                        display.getCurrentStage():setFocus( nil )
                        t.isFocus = false
                end

        end

    return true

end


Circle:addEventListener( "touch", onTouch )
ramp:addEventListener( "touch", onTouch )
ramp2:addEventListener( "touch", onTouch )
