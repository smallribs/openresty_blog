local config = require("Config.config")
local database = {}

function database.connection()
    local mysql = require("resty.mysql")
    local db, err = mysql:new()
    db:set_timeout(1000)
    local res, err, errno, sqlstate = db:connect(config["database"])
    return db
end

function database.query(sql, db)
    local res, err, errcode, sqlstate = db:query(sql)
    return res
end

function database.send_query(sql, db)
    local res, err, errcode, sqlstate = db:send_query(sql)
    return res
end


return database