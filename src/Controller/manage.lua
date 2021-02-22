local manage = {}
local database = require("Core.database")

function manage.index()
    ngx.say("token not exxits")
    local utils = require("Common.utils")
    if utils.is_post() then
        ngx.req.read_body()
        local args, err = ngx.req.get_post_args()
        token = args['token']
        if manage.verify(token) then
        end
    end
end

function manage.login()
    local utils = require("Common.utils")
    if utils.is_post() then
        ngx.req.read_body()
        local args, err = ngx.req.get_post_args()
        username = args['username']
        password = utils.sha1(args['password'])
        local db = database.connection()
        local sql = string.format("SELECT username, password FROM users WHERE username = '%s' and password = '%s'", username, password)
        local res = database.query(sql, db)
        if #res == 0 then
            ngx.say("Login Fail")
        else
            token = manage.generate_token(username)
            ngx.header["Set-Cookie"]  = "token=" .. token
            ngx.say("Login Success")
        end
    else
        ngx.say("Hello")
    end
end

function manage.create(data)
    ngx.say("create")
end

function manage.destory(id)
end

function manage.revise(data)
end

function manage.is_login()
end

function manage.logout()
    local session = require("resty.session").start()
    session:destroy()
end

function manage.generate_token(username)
    local cjson = require("cjson")
    local jwt = require("resty.jwt")
    local jwt_token = jwt:sign(
        "lua-resty-jwt",
        {
            header={typ="JWT", alg="HS256"},
            payload={username=username, time=os.time() + 3600}
        }
    )
    return jwt_token
end

function manage.verify(token)
    local cjson = require "cjson"
    local jwt = require "resty.jwt"
    local jwt_obj = jwt:verify("lua-resty-jwt", token)
    local t = cjson.encode(jwt_obj)
    local username = jwt_obj["payload"]["username"]
    local time = jwt_obj["payload"]["time"]
    if not username then
        return false
    elseif tonumber(time) < os.time() then
        return false
    else
        return true
    end
end

return manage