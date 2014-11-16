function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  local width, height, _ = love.window.getMode()
  self = {
    living_cells = {
      {0, 0},
      {1, 1},
      {2, 1},
      {2, 3},
    },
    width = width,
    height = height,
    line_width = 1,
    cell_size = 9,
  }
  self.grid_step = self.line_width + self.cell_size
  self.position_x = self.width / 2 / self.grid_step
  self.position_y = self.height / 2 / self.grid_step
end

function love.keypressed(key, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  local _
  self.width, self.height, _ = love.window.getMode()
end

function love.draw()
  love.graphics.setBackgroundColor(255,255,255)
  love.graphics.clear()

  draw_living_cells(self)
  draw_grid_lines(self)

  love.graphics.setColor(128,128,255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 5, 5)
end

function draw_living_cells(self)
  love.graphics.setColor(0,0,0)
  cells = self.living_cells
  for i, cell in ipairs(cells) do
    grid_x = cell[1] + self.position_x
    grid_y = -cell[2] + self.position_y
    love.graphics.rectangle("fill",
      grid_x * self.grid_step,
      grid_y * self.grid_step,
      self.cell_size,
      self.cell_size
    )
  end
end

function draw_grid_lines(self)
  love.graphics.setColor(223,223,223)
  love.graphics.setLineWidth(self.line_width)

  for x=0,self.width,self.grid_step do
    love.graphics.line(x, 0, x, self.height)
  end
  for y=0,self.height,self.grid_step do
    love.graphics.line(0, y, self.width, y)
  end
end
