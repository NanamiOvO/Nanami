--Name : Hanting Yang
--Assignment #2  2/12/2019
--Include 4 functions: mapTable, concatMax, collatz, backSubs
--Tested with pa2_test.lua
--All tests successful

local pa2 = {}

function pa2.mapTable(f,t)
local table ={}
  for k, v in pairs(t) do
   table[k] = f(v)
  end
return table
end


function pa2.concatMax(s,int)
concat = int /string.len(s)
return string.rep(s, concat)
end

function pa2.collatz(k)
return function()
 local c = k
 if k>1 then
  if k % 2 == 0 then
  k = k *0.5
  else
  k = 3 * k + 1
  end
 return c
 end
 if k==1 then
  k = 0
 return c
 end
end
end



function pa2.backSubs(s)
local str = string.reverse(s)
coroutine.yield("")
for i = 0, string.len(str) - 1 do
 for j = 1 , string.len(str) - i do
  coroutine.yield(str:sub(j, j + i ))
 end
end
return str
end



return pa2


  

