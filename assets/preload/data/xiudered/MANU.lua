-- Script realizzato da Nex_isDumb
function onCreatePost()
    debugMode = true;
    -- Schermo Nero
    makeLuaSprite("blackOut", "", -10, -10)
    makeGraphic("blackOut", screenWidth + 20, screenHeight + 20, '000000')
    setObjectCamera("blackOut", "hud")
    setProperty("blackOut.alpha", 0.00001)  -- Mettere 0 potrebbe farlo laggare in seguito, quindi
    addLuaSprite("blackOut", true)

    -- Il Testo
    makeLuaText("tuaMadre", "AH", screenWidth, 0, 290)
    setTextFont("tuaMadre", "magmasangue.otf")
    setTextSize("tuaMadre", 108)
    setTextBorder("tuaMadre", 1, '000000')
    setProperty("tuaMadre.visible", false)
    addLuaText("tuaMadre")
end

function onBeatHit()
    if curBeat == 12 or curBeat == 80 then
        doTweenAlpha("nutOnFort", "fortnut1", 0.00001, 0.1, "quadIn")
    elseif curBeat == 48 or curBeat == 112 then
        doTweenAlpha("nutOnFort", "fortnut1", 1, 0.1, "quadIn")
    elseif curBeat == 148 then
        removeFromGroup("members", getObjectOrder("fortnut1"))
        removeFromGroup("members", getObjectOrder("fortnut2"))
    elseif curBeat == 142 or curBeat == 316 then
        doTweenAlpha("blackOuted", "blackOut", 1, 0.8, "quadIn")
    elseif curBeat == 156 then
        if flashingLights then cameraFlash("hud", "FFFFFF", 1, true) end
        setProperty("blackOut.alpha", 0.00001)
        setProperty("tuaMadre.visible", false)
        if timeBarType == "Nome canzone" then
            setTextString("timeTxt", "xiuder-EDD")
        end
    end
end

function onStepHit()
    if curStep == 589 then
        setProperty("tuaMadre.visible", true)
    elseif curStep == 592 then
        setTextString("tuaMadre", "AH AH")
    elseif curStep == 595 then
        setTextString("tuaMadre", "AH AH AH")
    elseif curStep == 598 then
        setTextString("tuaMadre", "AH AH AH AH")
    elseif curStep == 600 then
        setTextString("tuaMadre", "AH AH AH AH AH")
    elseif curStep == 606 then
        setTextString("tuaMadre", "MANU!")
    elseif curStep == 613 then
        setTextString("tuaMadre", "TUA")
    elseif curStep == 615 then
        setTextString("tuaMadre", "TUA MADRE!")
    elseif curStep == 1280 then
        setProperty("tuaMadre.visible", true)
        setTextString("tuaMadre", "NON")
    elseif curStep == 1283 then
        setTextString("tuaMadre", "NON SI")
    elseif curStep == 1285 then
        setTextString("tuaMadre", "NON SI SA")
    elseif curStep == 1287 then
        setTextString("tuaMadre", "NON SI SA COME")
    elseif curStep == 1289 then
        setTextString("tuaMadre", "NON SI SA COME MAI")
    end
end