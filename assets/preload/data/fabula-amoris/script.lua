function onSongStart()
	for i = 0, 7, 1 do
		noteTweenAlpha(tostring(i), i, 0, 0.1, linear)
	end
	noteTweenX("initialPos_0", 0, 700, 0.1, linear)
	noteTweenX("initialPos_1", 1, 815, 0.1, linear)
	noteTweenX("initialPos_2", 2, 930, 0.1, linear)
	noteTweenX("initialPos_3", 3, 1045, 0.1, linear)
end

function onStepHit()
	if curStep == 96 then
		for i = 0, 3, 1 do
			noteTweenAlpha(tostring(i + 10), i, 1, 3, linear)
		end
		doTweenAlpha('blakeHeartVisible_1', 'blakeHeart', 1, 3, 'linear')
	end

	if curStep == 272 then
		doTweenAlpha('blakeHeartVisible_2', 'blakeHeart', 0, 2, 'linear')
	end

	if curStep == 288 then
		noteTweenX("sideSwitch_1_0", 0, 135, 2.5, 'sineinout')
		noteTweenX("sideSwitch_1_1", 1, 250, 2.5, 'sineinout')
		noteTweenX("sideSwitch_1_2", 2, 365, 2.5, 'sineinout')
		noteTweenX("sideSwitch_1_3", 3, 480, 2.5, 'sineinout')
		for i = 0, 3, 1 do
			noteTweenAngle(tostring(i + 20), i, 360, 2.5, 'sineinout')
		end
	end

	if curStep == 304 then
		doTweenAlpha('sophieHeartVisible_1', 'sophieHeart', 1, 3, 'linear')
	end

	if curStep == 464 then
		doTweenAlpha('sophieHeartVisible_2', 'sophieHeart', 0, 1, 'linear')
	end

	if curStep == 467 then
		noteTweenX("sideSwitch_2_0", 0, 700, 1.5, 'sineinout')
		noteTweenX("sideSwitch_2_1", 1, 815, 1.5, 'sineinout')
		noteTweenX("sideSwitch_2_2", 2, 930, 1.5, 'sineinout')
		noteTweenX("sideSwitch_2_3", 3, 1045, 1.5, 'sineinout')
		for i = 0, 3, 1 do
			noteTweenAngle(tostring(i + 30), i, 0, 1.5, 'sineinout')
		end
	end

	if curStep == 471 then
		doTweenAlpha('blakeHeartVisible_3', 'blakeHeart', 1, 1, 'linear')
	end

	if curStep == 528 then
		noteTweenX("sideSwitch_3_0", 0, 418, 3, 'sineinout')
		noteTweenX("sideSwitch_3_1", 1, 533, 3, 'sineinout')
		noteTweenX("sideSwitch_3_2", 2, 648, 3, 'sineinout')
		noteTweenX("sideSwitch_3_3", 3, 763, 3, 'sineinout')
	end

	if curStep == 553 then
		doTweenAlpha('sophieHeartVisible_3', 'sophieHeart', 0.5, 0.5, 'linear')
	end

	if curStep == 558 then
		noteTweenX("sideSwitch_4_0", 0, 700, 3, 'sineinout')
		noteTweenX("sideSwitch_4_1", 1, 815, 3, 'sineinout')
		noteTweenX("sideSwitch_4_2", 2, 930, 3, 'sineinout')
		noteTweenX("sideSwitch_4_3", 3, 1045, 3, 'sineinout')
	end

	if curStep == 564 then
		doTweenAlpha('sophieHeartVisible_3', 'sophieHeart', 0, 1, 'linear')
	end

	if curStep == 592 then
		noteTweenX("sideSwitch_5_0", 0, 135, 1.5, 'sineinout')
		noteTweenX("sideSwitch_5_1", 1, 250, 1.5, 'sineinout')
		noteTweenX("sideSwitch_5_2", 2, 365, 1.5, 'sineinout')
		noteTweenX("sideSwitch_5_3", 3, 480, 1.5, 'sineinout')
		for i = 0, 3, 1 do
			noteTweenAngle(tostring(i + 20), i, 360, 1.5, 'sineinout')
		end
	end

	if curStep == 608 then
		doTweenAlpha('sophieHeartVisible_4', 'sophieHeart', 1, 0.2, 'linear')
		doTweenAlpha('blakeHeartVisible_4', 'blakeHeart', 0, 0.2, 'linear')
	end

	if curStep == 656 then
		noteTweenX("sideSwitch_3_0", 0, 418, 3, 'sineinout')
		noteTweenX("sideSwitch_3_1", 1, 533, 3, 'sineinout')
		noteTweenX("sideSwitch_3_2", 2, 648, 3, 'sineinout')
		noteTweenX("sideSwitch_3_3", 3, 763, 3, 'sineinout')
	end

	if curStep == 681 then
		doTweenAlpha('blakeHeartVisible_5', 'blakeHeart', 0.5, 0.5, 'linear')
	end

	if curStep == 686 then
		noteTweenX("sideSwitch_4_0", 0, 135, 3, 'sineinout')
		noteTweenX("sideSwitch_4_1", 1, 250, 3, 'sineinout')
		noteTweenX("sideSwitch_4_2", 2, 365, 3, 'sineinout')
		noteTweenX("sideSwitch_4_3", 3, 480, 3, 'sineinout')
	end

	if curStep == 692 then
		doTweenAlpha('blakeHeartVisible_6', 'blakeHeart', 0, 1, 'linear')
	end

	if curStep == 716 then
		noteTweenX("sideSwitch_3_0", 0, 418, 2.5, 'sineinout')
		noteTweenX("sideSwitch_3_1", 1, 533, 2.5, 'sineinout')
		noteTweenX("sideSwitch_3_2", 2, 648, 2.5, 'sineinout')
		noteTweenX("sideSwitch_3_3", 3, 763, 2.5, 'sineinout')
	end

	if curStep == 736 then
		doTweenAlpha('blakeHeartVisible_7', 'blakeHeart', 1, 0.1, 'linear')
	end

	if curStep == 768 then
		doTweenAlpha('sophieHeartVisible_5', 'sophieHeart', 0, 0.01, 'linear')
		doTweenAlpha('blakeHeartVisible_8', 'blakeHeart', 0, 0.01, 'linear')
	end

	if curStep == 784 then
		noteTweenX("finalPos_left_0", 0, 135, 0.01, 'sineinout')
		noteTweenX("finalPos_left_1", 1, 250, 0.01, 'sineinout')
		noteTweenX("finalPos_left_2", 2, 365, 0.01, 'sineinout')
		noteTweenX("finalPos_left_3", 3, 480, 0.01, 'sineinout')

		noteTweenX("finalPos_right_4", 4, 700, 0.01, 'linear')
		noteTweenX("finalPos_right_5", 5, 815, 0.01, 'linear')
		noteTweenX("finalPos_right_6", 6, 930, 0.01, 'linear')
		noteTweenX("finalPos_right_7", 7, 1045, 0.01, 'linear')

		doTweenAlpha("left_control_visible", 'FAControlLeftText', 1, 0.01, 'linear')
	end

	if curStep == 792 then
		for i = 4, 7, 1 do
			noteTweenAlpha(tostring(i + 50), i, 1, 0.01, 'linear')
		end
		doTweenAlpha("right_control_visible", 'FAControlRightText', 1, 0.01, 'linear')
	end

	if curStep == 800 then
		doTweenAlpha("right_control_invisible", 'FAControlRightText', 0, 0.01, 'linear')
		doTweenAlpha("left_control_invisible", 'FAControlLeftText', 0, 0.01, 'linear')
		doTweenAlpha('sophieHeartVisible_6', 'sophieHeart', 1, 0.01, 'linear')
		doTweenAlpha('blakeHeartVisible_9', 'blakeHeart', 1, 0.01, 'linear')
	end
end