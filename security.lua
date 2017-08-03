keypad = require("component").os_keypad
door = require("component").os_doorcontroller
os = require("os")
event = require("event")
ser = require("serialization")

keypad.setEventName("keypad")
keypad.setDisplay("")

customButtons = {
  "1","2","3",
  "4","5","6",
  "7","8","9",
  "*","0","#"
}

keypad.setKey(customButtons)

function correct()
  keypad.setDisplay("Open")
  door.open()
  os.sleep(3)
  door.close()
  display = ""
  entered = {}
end

function wrong()
  display = "Denied"
  entered = {}
  timeout = event.timer(2, clearDisp, 1)
end

function clearDisp()
  display = ""
  updateScreen()
end

function updateScreen()
  keypad.setDisplay(display)
end

function checkCode(a,b)

  if ser.serialize(a) == ser.serialize(b) then
    correct()
  else
    wrong()
  end
end

timeout = 0
code = {"1","2","3","4"}
entered = {}
display = ""

door.close() 

while true do
  updateScreen()

  e,_, button, label, value = event.pullMultiple("keypad","redstone_changed")

  if e == "keypad" then
    event.cancel(timeout)

    if label == "#" then
      checkCode(entered,code)
    end

    if label == "*" then
      display = ""
      entered = {}
    end

    if label ~= "#" and label ~= "*" then
      table.insert(entered, label)
      display = ""
      for i in ipairs(entered) do
        display = display .. "*"
      end
    end
  end

  if e == "redstone_changed" then
    if value == 15 then
      correct()
    end
  end

print("-------debug-------")
print("event:   "..e)
print("button:  "..label)
print("display: "..display)
print("code:")
print(ser.serialize(code))
print("entered:")
print(ser.serialize(entered))

end
