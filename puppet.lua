-- puppet script
-- formatted for slack

-- slack incoming webhook info
local team = ""
local token = ""
local uri = "https://" .. team .. ".slack.com/services/hooks/incoming-webhook"
local cmd = "/puppet"

-- parse incoming payload
local form = request and request.form or {}
local input = form.text or "foobot :symbols: hello world!"
local channel = form.channel_name
local puppeteer = form.user_name
local command = form.command

-- create bot table to be sent using incoming webhook
local bot = {
    text = ""
}

-- ensure script is being accessed correctly
if command ~= cmd then
    return 404
end

if channel then
    bot.channel = "#" .. channel
end

-- parse input
local i = 0
for match in input:gmatch("%S+") do
    if i == 0 then
        bot.username = match
        if storage[bot.username] then
            bot.icon_emoji = storage[bot.username]
        end
    elseif i == 1 and match:find("^:.+:$") then
        bot.icon_emoji = match
    else
        bot.text = bot.text .. " " .. match
    end

    i = i + 1
end

-- provide guidance for incorrect inputs
if i < 1 then
    return "<name> <icon> <message>"
end

-- store bot icon for ease of use later
if bot.icon_emoji then
    storage[bot.username] = bot.icon_emoji
end

-- send bot to incoming webhook
local response = http.request {
    url = uri,
    method = "POST",
    data = {
        payload = json.stringify(bot)
    },
    params = {
        token = token
    }
}

return response.statuscode