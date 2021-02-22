local utils = {}

function utils.R(status_code, t)
    local json = require("cjson")
    ngx.header["Content-Type"]  = "application/json"
    ngx.say(json.encode(t))
    ngx.exit(status_code)
end

function utils.sha1(str)
    return ngx.encode_base64(ngx.sha1_bin(str))
end

function utils.hmac_sha1(str)
    local key = "my_secret"
    return ngx.encode_base64(ngx.hmac_sha1(key, str))
end

function utils.md5(str)
    return ngx.encode_base64(ngx.md5_bin(str))
end

function utils.is_post()
    return ngx.req.get_method() == 'POST' or false
end

return utils