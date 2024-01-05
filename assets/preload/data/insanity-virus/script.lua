function onStepHit()
    if curStep == 1600 then
        cameraFlash("camOther", "white", 1, true)
        setProperty("zoomRate", 0.9)
        setProperty("cameraEffectState", 1)
        setProperty("cameraEffectZoom", 1.5)
    end

    if curStep == 1664 then
        setProperty("cameraEffectZoom", 1.675)
    end

    if curStep == 1712 then
        setProperty("cameraEffectZoom", 1.2)
    end

    if curStep == 1760 then
        setProperty("cameraEffectState", 2)
        setProperty("cameraEffectZoom", 1.5)
    end

    if curStep == 1824 then
        setProperty("zoomRate", 0.9)
        setProperty("cameraEffectZoom", 2.2)
    end

    if curStep == 1888 then
        cameraFlash("camOther", "white", 1, true)
        setProperty("cameraEffectState", 3)
        setProperty("zoomRate", 0.9)
        setProperty("cameraEffectZoom", 1.65)
    end

    if curStep == 1952 then
        setProperty("zoomRate", 1.2)
        setProperty("cameraEffectZoom", 2.05)
    end

    if curStep == 1984 then
        setProperty("cameraEffectZoom", 2.45)
    end

    if (curStep == 504) or (curStep == 1753) or (curStep == 2457) or (curStep == 2713) or (curStep == 2969) or (curStep == 3353) or (curStep == 3609) then
        doTweenZoom("coolzoombecausewhynot", "camHUD", 1.2, 0.86, "cubein")
    end

    if curStep == 2016 then
        setProperty("defaultCamZoom", 1)
    end

    if curStep == 2208 then
        doTweenAlpha("NOPE", "overlayBlackScreen", 0, 0.01, "linear")
    end
    
    if ((curBeat >= 128) and (curBeat <= 192)) or ((curBeat >= 224) and (curBeat <= 288)) then
        if ((curBeat + 1) % 4 == 0) or ((curBeat - 142 + 1) % 16 == 0) then
            setProperty("ERDrop", true)
        else
            setProperty("ERDrop", false)
        end

        if ((curBeat) % 4 == 0) or ((curBeat - 142) % 16 == 0) then
            cameraShake("camHud", 0.0035, 0.05)
        end
    end

    if ((curBeat >= 399) and (curBeat < 424)) or ((curBeat >= 439) and (curBeat < 496)) then
        if (curBeat + 1) % 4 == 0 then
            setProperty("ERDrop", true)
        end
        if ((curBeat - 410) % 8 == 0) or ((curBeat - 405) % 8 == 0) then
            setProperty("ERDrop", false)
        end

        if (curBeat) % 4 == 0 then
            cameraShake("camHud", 0.0035, 0.05)
        end
    end

    if ((curBeat >= 424) and (curBeat < 440)) or ((curBeat >= 839) and (curBeat < 902)) or ((curBeat >= 551) and (curBeat < 616)) or ((curBeat >= 680) and (curBeat < 744)) then
        if (curBeat + 1) % 2 == 0 then
            setProperty("ERDrop", true)
        else
            setProperty("ERDrop", false)
        end

        if (curBeat) % 2 == 0 then
            cameraShake("camHud", 0.0035, 0.05)
        end
    end

    if ((curBeat >= 496) and (curBeat < 551)) or (curBeat == 744) or (curBeat == 904) then
        setProperty("ERDrop", false)
    end

    if (curBeat >= 615) and (curBeat < 680) then
        if ((curBeat + 1 - 616) % 12 == 0) or ((curBeat + 1 - 619) % 16 == 0) or ((curBeat + 1 - 622) % 8 == 0) or ((curBeat + 1 - 625) % 16 == 0) then
            setProperty("ERDrop", true)
        else
            setProperty("ERDrop", false)
        end
    end
end