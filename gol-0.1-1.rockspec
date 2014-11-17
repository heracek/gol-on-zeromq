package = "gol"
version = "0.1-1"
source = {
  url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
  summary = "Game of Life on ZeroMQ",
  -- detailed = "*** please enter a detailed description ***",
  -- homepage = "*** please enter a project homepage ***",
  -- license = "*** please specify a license ***"
}
dependencies = {
  "lzmq-ffi",
  "dkjson",
}
build = {
  type = "builtin",
  modules = {
  }
}
