function onStepHit()
    if middlescroll == true then
        if curStep == 896 then
            for i = 0, 3, 1 do
                noteTweenAlpha(tostring(i), i, 0, 1.2, 'cubeinout')
            end
        end

        if curStep == 1936 then
            for i = 0, 3, 1 do
                noteTweenAlpha(tostring(i), i, 1, 0.1, 'linear')
            end
        end

        if curStep == 907 then
            noteTweenX("initialPos_0", 4, 732, 0.5, 'backin')
            noteTweenX("initialPos_1", 5, 844, 0.5, 'backin')
            noteTweenX("initialPos_2", 6, 956, 0.5, 'backin')
            noteTweenX("initialPos_3", 7, 1068, 0.5, 'backin')
        end

        if curStep == 1931 then
            noteTweenX("initialPos_0", 4, 412, 0.5, 'backin')
            noteTweenX("initialPos_1", 5, 524, 0.5, 'backin')
            noteTweenX("initialPos_2", 6, 636, 0.5, 'backin')
            noteTweenX("initialPos_3", 7, 748, 0.5, 'backin')
        end

    end
end