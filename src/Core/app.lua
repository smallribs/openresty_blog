local app = {}

function app.start()
    app.router()
end

function app.router()
    local uri = ngx.var.uri
    local fields = {}
    string.gsub(uri, '([^/]+)', function (result) fields[#fields+1] = result end)
    controller_var = fields[1]
    method_var = fields[2]

    controller = require("Controller." .. controller_var)
    controller[method_var]()
end

return app