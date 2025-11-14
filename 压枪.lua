userInfo = {
    debug = 1,
    cpuLoad = 1,
    startControl = "scrolllock", -- 启动控制 (scrolllock, capslock, numlock)
    currentGun = "TL",
    recoilTriggerButton = 4,--压枪按键，0为开火自动压枪
}

delta = {
    gun = {},
    gunOptions = {},
    gunIndex = 1,
    sleep = userInfo.cpuLoad,
    sleepRandom = { userInfo.cpuLoad, userInfo.cpuLoad + 5 },
    startTime = 0,
    currentTime = 0,
    bulletIndex = 0,
    recoilActive = false,
}

function debugLog(message)
    if userInfo.debug == 1 then
        OutputLogMessage(tostring(message) .. "\n")
    end
end

debugLog("脚本初始化开始...")

function delta.isAimingState()
    return IsMouseButtonPressed(3)
end

-- 每把枪独立配置弹道 + 倍率
delta["TL"] = function()
    debugLog("初始化压枪数据...")
    return {
        interval = 78,
        ratio = 1,
        ballistic = {
            { 1, -1, 15 },
            { 2, -1, 13 },
            { 8, 1, 10 },
            { 15, -3, 14 },
            { 25, -2, 13 },
            {30, -2, 13},
        }
    }
end

delta["M14"] = function()
    debugLog("初始化 M14 压枪数据...")
    return {
        interval = 82,
        ratio = 1,
        ballistic = {
            { 1, -1, 30 },
            { 2, -1, 35 },
            { 5, 0, 12 },
            { 8, 0, 12 },
            {14, -4, 12},
            {20, -4, 10},
            {30, 0, 10},
        }
    }
end
delta["M14_1"] = function()
    debugLog("初始化 M14 压枪数据...")
    return {
        interval = 82,
        ratio = 1,
        ballistic = {
            { 1, -8, 80 },
            { 2, -5, 70 },
            { 5, -5, 60 },
            { 8, 0, 30 },
            { 13, -6, 25 },
            {17, -13, 25},
            {20, -13, 20},
            {30, 0, 20},
        }
    }
end

function delta.execOptions(options)
    debugLog("计算弹道配置")
    local ballisticConfig = {}

    for i = 1, #options.ballistic do
        local startIndex = options.ballistic[i][1]
        local dx = options.ballistic[i][2]
        local dy = options.ballistic[i][3]
        local endIndex

        if i < #options.ballistic then
            endIndex = options.ballistic[i + 1][1] - 1
        else
            endIndex = startIndex
        end

        for j = startIndex, endIndex do
            ballisticConfig[j] = {
                dx = dx,                          -- X轴不受ratio影响（如需改，请说明）
                dy = dy * options.ratio           -- Y轴乘比例
            }
        end
    end

    local amount = 0
    for _ in pairs(ballisticConfig) do amount = amount + 1 end

    debugLog("弹道计算完成，子弹数: " .. amount)
    return {
        amount = amount,
        interval = options.interval,
        ballistic = ballisticConfig,
        maxBullet = options.ballistic[#options.ballistic][1],  -- 最大子弹编号限制
    }
end

function IsStart ()
    return IsKeyLockOn(userInfo.startControl)
end

function delta.init()
    debugLog("初始化枪支配置...")
    local gunName = userInfo.currentGun

    local gunFunc = delta[gunName]
    if not gunFunc then
        debugLog("错误：未定义枪支：" .. tostring(gunName))
        return
    end

    delta.gun[1] = gunName
    delta.gunIndex = 1
    local rawOptions = gunFunc()
    local processedOptions = delta.execOptions(rawOptions)
    delta.gunOptions[1] = processedOptions

    debugLog("初始化完成，当前武器：" .. gunName)
end

function delta.auto(options)
    if not options or not options.interval or not options.amount then
        debugLog("错误：无效压枪配置")
        return false
    end

    local deltaTime = delta.currentTime - delta.startTime
    if deltaTime < 0 then deltaTime = 0 end

    local currentBullet = math.floor(deltaTime / options.interval) + 1

    if currentBullet > options.maxBullet then
        debugLog("已超过最大配置子弹数，跳出压枪")
        return false
    end

    if currentBullet ~= delta.bulletIndex then
        delta.bulletIndex = currentBullet

        local data = options.ballistic[currentBullet]
        if not data then
            debugLog("未找到弹道数据 bullet=" .. currentBullet)
            return false
        end

        MoveMouseRelative(data.dx, data.dy)--压枪代码，不想使用可以注释掉
        debugLog("压枪执行: 子弹=" .. currentBullet .. " X位移=" .. data.dx .. " Y位移=" .. data.dy)
    end

    Sleep(math.random(delta.sleepRandom[1], delta.sleepRandom[2]))
    return true
end

function delta.toggleRecoil(toggle)
    delta.recoilActive = toggle
    if toggle then
        delta.startTime = GetRunningTime()
        delta.bulletIndex = 0
        debugLog("压枪模式激活")
    else
        debugLog("压枪模式关闭")
    end
end

function OnEvent(event, arg, family)
    if not IsStart() then return end
    if event == "MOUSE_BUTTON_PRESSED" and (arg == userInfo.recoilTriggerButton or userInfo.recoilTriggerButton == 0) then
        delta.toggleRecoil(true)
    end

    if event == "MOUSE_BUTTON_RELEASED" and (arg == userInfo.recoilTriggerButton or userInfo.recoilTriggerButton == 0) then
        delta.toggleRecoil(false)
    end

    if event == "MOUSE_BUTTON_PRESSED" and arg == 1 and delta.recoilActive then
        PressKey("lshift")
        debugLog("开始压枪序列")

        local options = delta.gunOptions[delta.gunIndex]
        if not options then
            debugLog("错误：未加载当前枪配置")
            return
        end

        delta.startTime = GetRunningTime()
        delta.bulletIndex = 0
        Sleep(10)

        local entry = 0
        while IsMouseButtonPressed(1) and delta.recoilActive do
            delta.currentTime = GetRunningTime()
            if not delta.auto(options) then break end
            entry = entry + 1
        end
        ReleaseKey("lshift")
        debugLog("压枪序列结束，执行次数: " .. entry)
    end

    if event == "PROFILE_DEACTIVATED" then
        debugLog("脚本停用")
        EnablePrimaryMouseButtonEvents(false)
    end
end

debugLog("启用鼠标监听...")
EnablePrimaryMouseButtonEvents(true)
delta.init()
debugLog("初始化完成，等待输入...")
