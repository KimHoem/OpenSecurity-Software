term = require("term")

function log(level, msg)
    if level == 1 then term.write("[INFO]")
    elseif level == 2 then term.write("[DEBUG]")
    elseif level == 3 then term.write("[WARNING]")
    elseif level == 4 then term.write("[CRITICAL]")
    else
        term.write("[ ? ]")
    end

    term.write(msg .. "\n")
end
