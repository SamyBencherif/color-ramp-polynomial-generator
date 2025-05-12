
local plots = {}
local selectedPoint

function love.load()
    love.window.setTitle("Color Ramp Polynomial Generator")

    plots[#plots+1] = {x=10, y=10, points={{x = 0, y = 0}, {x = .5, y = .5}, {x = 1, y = 1}}, r=1, g=0, b=0, quad={a=1, b=0, c=0}}
    plots[#plots+1] = {x=120, y=10, points={{x = 0, y = 0}, {x = .5, y = .5}, {x = 1, y = 1}}, r=0, g=1, b=0, quad={a=1, b=0, c=0}}
    plots[#plots+1] = {x=230, y=10, points={{x = 0, y = 0}, {x = .5, y = .5}, {x = 1, y = 1}}, r=0, g=0, b=1, quad={a=1, b=0, c=0}}
end

function draw_plot(x, y)
    love.graphics.setColor(.5, .5, 0)

    for v=0,10 do
        love.graphics.line(x, y+10*v, x+100, y+10*v)
        love.graphics.line(x+10*v, y, x+10*v, y+100)
    end
end


function love.draw()

    for p=1,#plots do
        draw_plot(plots[p].x, plots[p].y)

        for i=1,#plots[p].points do

            local px = plots[p].x + 100*plots[p].points[i].x
            local py = plots[p].y + 100 - 100*plots[p].points[i].y

            love.graphics.setColor(plots[p].r, plots[p].g, plots[p].b, .2)
            love.graphics.circle("fill", px, py, 6)
            love.graphics.setColor(plots[p].r, plots[p].g, plots[p].b)
            love.graphics.circle("fill", px, py, 2)

            if love.mouse.isDown(1) and math.pow(love.mouse.getX() - px, 2) + math.pow(love.mouse.getY() - py, 2) < 36 and not selectedPoint then
                selectedPoint = {plot=p, point=i}
            end
        end

        local resolution = 20
        for i=1,resolution do
            local x1 = (i-1)/resolution
            local x2 = i/resolution
            local y1 = 1-plots[p].quad.a * x1 * x1 + plots[p].quad.b * x1 + plots[p].quad.c
            local y2 = 1-plots[p].quad.a * x2 * x2 + plots[p].quad.b * x2 + plots[p].quad.c

            love.graphics.line(plots[p].x + 100*x1, plots[p].y + 100*y1, plots[p].x + 100*x2, plots[p].y + 100*y2)
        end
    end

    if not love.mouse.isDown(1) then
        selectedPoint = nil
    end

    if selectedPoint then
        plots[selectedPoint.plot].points[selectedPoint.point].x = math.max(0, math.min((love.mouse.getX() - plots[selectedPoint.plot].x)/100, 1))
        plots[selectedPoint.plot].points[selectedPoint.point].y = math.max(0, math.min(1-(love.mouse.getY() - plots[selectedPoint.plot].y)/100, 1))
    end
end

function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then
      love.event.quit()
   end
end