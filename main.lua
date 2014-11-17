require "luarocks.loader"
local zmq = require "lzmq"
local json = require "dkjson"

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
    zmq = {},
  }
  self.grid_step = self.line_width + self.cell_size
  self.position_x = self.width / 2 / self.grid_step
  self.position_y = self.height / 2 / self.grid_step

  self.zmq.ctx = zmq.context()
  self.zmq.socket = self.zmq.ctx:socket{ zmq.PAIR,
    linger = 1000, rcvtimeo = 1000,
    bind = "tcp://127.0.0.1:5555",
  }
end

function love.keypressed(key, isrepeat)
  if key == "escape" then
    love.event.quit()
  elseif key == "up" then
    self.position_y = self.position_y + 1
  elseif key == "down" then
    self.position_y = self.position_y - 1
  elseif key == "left" then
    self.position_x = self.position_x + 1
  elseif key == "right" then
    self.position_x = self.position_x - 1
  end
end

function love.update(dt)
  local _
  self.width, self.height, _ = love.window.getMode()

  local world_json = self.zmq.socket:recv(zmq.DONTWAIT)
  if world_json then
    local world, pos, err = json.decode(world_json, 1, nil)
    if err then
      print ("Error:", err)
    else
      self.living_cells = world.living_cells
    end
  end
end

function love.draw()
  love.graphics.setBackgroundColor(255,255,255)
  love.graphics.clear()

  draw_living_cells(self)
  draw_grid_lines(self)

  love.graphics.setColor(128,128,255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 5, 5)
end

function love.quit()
  self.zmq.socket:close(0)
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
