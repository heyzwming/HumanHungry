package.path = package.path .. ";./lua_scripts/?.lua"
require("Config")   
require("PlayBot")


--[[        
Lua 提供高级的 require 函数来加载运行库。粗略的说 require 和 dofile 完成同样的功能但有两点不同：
1. require 会搜索目录加载文件
2. require 会判断是否文件已经加载避免重复加载同一文件。
由于上述特征，require在 Lua 中是加载库的更好的函数         
--]]