package;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class STErrors
{
	public static var errorMessages:Array<String> = [];

	public static var onScreenErrors:FlxTypedGroup<FlxText>;

	public static function displayErrors(displayLines:Int = 1, ?camera:FlxCamera)
	{
		if (errorMessages == []) return;
		for (i in 0...displayLines)
		{
			var error:FlxText = new FlxText(0, FlxG.height - 13, 0, errorMessages[0], 13);
			error.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.RED, LEFT);
			onScreenErrors.add(error);
			error.cameras = [camera];
            error.ID = onScreenErrors.length;
            errorMessages.remove(errorMessages[0]);
            onScreenErrors.forEach(function(errorMessage:FlxText) {
                errorMessage.y -= 13;
                errorMessage.alpha -= 0.05;
                if (errorMessage.alpha == 0) {
                    onScreenErrors.members.remove(errorMessage);
                    errorMessage.destroy();
                }
            });
		}
	}

	public static function resetErrors()
	{
		errorMessages = [
			'zero lifesign signals detected..._attempting automatic dimensional relocation_',
            '[ERROR] -- called from SYSTEM_:/main::/onUpdate lifeSigns:/core:/readings [logic error]',
			'[ERROR] -- called from SYSTEM_:/main::/onUpdate lifeSigns:/core:/callbackResponses_',
			'[ERROR] -- called from SYSTEM_:/main::/onUpdate:/automations --> data does not support expected readings',
			'[ERROR] -- logic error called from SYSTEM_:/location:/currentLocation --> location does not match main timeline location',
			'[ERROR] -- called from SYSTEM_:/key:/auto_Responses --> null object with key: *death*',
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			'[ERROR] -- called from SYSTEM_:/key:/auto_Responses --> UNABLE TO ACCESS LOCKED AUTORESPONSE KEY *auto_relocation*',
			'[ERROR] -- called from SYSTEM_:/key:/auto_Responses --> runtime error calling keys: FATAL_ERROR: 0xr906H98S6Uw400',
			'[ERROR] -- [HARDWARE ERROR]> system heartbeat sensor recieving conflicting data',
			'[ERROR] -- [HARDWARE ERROR]> system neurological response --> neurological inputs detected [LOGIC ERROR] zero neuro signal',
			'[ERROR] -- [HARDWARE ERROR]> unable to access atomic dissociation; FATAL_ERROR: 0xr906H98S6Uw4H95ls86U2o6kAx',
			'[ERROR] -- [HARDWARE ERROR][LOGIC ERROR]> global sensory readings recieving conflicting illegal responses',
			'[ERROR] -- called from SYSTEM_:/callback:/PrimarySignal::/lowLifeSigns:/returmRel_ --> conflicting processes prevents dispatch of signal *retrunRel_*', 
			'[ERROR] -- logic error called from SYSTEM_:/sensoryInterface::/input --> sensory inputs detected from alternate timeline',
			'[ERROR] -- system runtime error; FATAL_ERROR: 0xy205H9507Tv5H9v5039h4m5l069Rr94mt7r9x35l05P15V3X5l', //buttherewasnothingicoulddo 
			'_attempting retry callback response with key *auto_relocation* to dimensional key *peace*...', 
			'[ERROR] -- Unable to locate dimension of key *peace*',
			'[ERROR] -- dimensional presence as returned null; FATAL_ERROR: 0x06s84W00H9s8K605t77T06r90603009h3nr94mv5Ax',
			RandException.generateRandomError(),
			'[ERROR] -- called from SYSTEM_:/location:/current::/getCurrent --> process has been locked_[conflicting responses]_',
			'[ERROR] -- called from SYSTEM_:/DATABASE:/locations --> callback responses InvalidActivityNameException',
			'[ERROR] -- called from SYSTEM_:/location:/callBackResponse --> process experiencing SystemCoreException_Unable to return callback response for null location',
			'_attempting dimensional location detection of individual key *SOPHIE*...', 
			'[ERROR] -- runtime error experienced by SYSTEM:/automation:/individual::/getLocation --> unable to locate null individual',
			'[ERROR] -- called from SYSTEM_:/DATABASE:/people --> access attempt return IntegrationExceptionEventArgs; FATAL_ERROR: 0x06s8508S3n00w4v58S06Ax',
			'[ERROR] -- called from SYSTEM_:/key:/people -> SYSTEM_:/DATABASE:/people --> individual of key *SOPHIE* does not exist',
			'[ERROR] -- UNABLE TO LOCATE INDIVIDUAL null FROM DATABASE; FATAL_ERROR: 0x06s800H9Q0034m066Uw4r90606M4s8z16k6kv54mAx',
			'[ERROR] _MAJOR TIMELINE ERROR DETECTED PLEASE RESOLVE IMMEDIATELY_ [ERROR]',
			'_attempting to detect probable error source...',
			'[ERROR] -- [HARDWARE ERROR] unexpected damage preventing sufficient functionality of system',
			'[ERROR] -- unable to locate probable source of error; FATAL_ERROR: 0x06s86U20205l602ow4L5062or99hH9v54mAx',
			'[ERROR] -- called from SYSTEM_:/failsafe --> an IllegalOperationError has occured [conflicting input data]',
			RandException.generateRandomError(),
			'[ERROR] -- called from SYSTEM_:/failsafe::/timeline:/autoDetect --> unexpected return from unknown hardware damage',
			'[ERROR] -- called from SYSTEM_:/failsafe::/timeline:/resolve --> a SystemCore exteption has occured::unable to execute function',
			'[ERROR] -- called from SYSTEM_:/failsafe --> attempt to access process locked system user data has resulted in an unexpected ArgumentError',
			'[ERROR] -- RUNTIME ERROR --> SYSTEM_:/failsafe; FATAL_ERROR: 0xr90650M400v53X03r950s806s8v5O2Ax', 
			'[ERROR] -- called from SYSTEM_:/main::failSafeResponses --> function failSafeResponses has experienced ExpectedExceptionData exception',
			'[ERROR] -- called from SYSTEM_:/main:/timeline --> an IllegalOperationError has occured _ current events cannot br properly managed _please resolve_',
			'[ERROR] -- called from SYSTEM_:/callback:/timeline::onDisruption:/detectDisrupt --> unable to detect location of timline error upon system callback',
			'[ERROR] -- called from SYSTEM_:/callback [TIMELINE ERROR]> unable to execute callback responses; FATAL_ERROR: 0xr9u6K6N3N301H9s8v5001p4mv50300',
			'_attempting automatic resolution of timeline error_..._...',
			//disconsolate rain
			'executing resolution attempt_...', //
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			'[ERROR] -- called from SYSTEM:/main:/failsafe --> runtime error occured during resolution attempt: FATAL_ERROR: 0xs85l20O240x37T6kz1Q04mr9s8z150v5u6v52o06Ax', //
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError() + ': FATAL_ERROR: 0xu65lH9O200x3M403z1H9w42o01z12Y06r95l4m9hAx',
			'[ERROR] -- detected illogical events__',
			'[ERROR] -- resolution attempt has experienced a [TIMELINE ERROR]: FATAL_ERROR: 0xr9062060z1P12o3n00u6z1052oH9',
			'_attempting to terminate current resolution attempt_',
			'_retrying automatic resolution to timeline error_..._...',
			//anamnesis
			'[ERROR] -- SYSTEM_:/failsafe --> failsafe process unresponsive_',
			'[ERROR] -- called from SYSTEM_:/main::failSafeResponses --> IllegalOperationError has occured',
			'[ERROR] -- called from SYSTEM_:/main --> unexpected SyntaxError has occured: FATAL_ERROR: 0x4m5l208SM4v54Ww4069Rv59hz13n4Wu6z106v5Ax',
			'[ERROR] -- called from SYSTEM_:/main:/timeline --> unexpected return from unknown hardware damage',
			RandException.generateRandomError(),
			'[ERROR] -- called from SYSTEM_:/DATABASE:/memoryData --> unknown access to memoryData process__denied access',
			'[ERROR] -- called from SYSTEM_:/DATABASE:/memoryData --> access to DATABASE:/memoryData has been denied due to illogical circumstances',
			'_UNKNOWN input sourced detected: FATAL_ERROR: 0xz19h00P1N3067T5l9h6Ur9z1y2z1N3w45l4mv5w4Ax',
			'_attempting execution of automatic system cleanup_',
			'[ERROR] -- called from SYSTEM_:/CleanUp::/passiveArchive --> unexpected runtimeError while accessing passiveArchive function',
			'[ERROR] -- called from SYSTEM_:/main::/onUpdate:/automations --> unable to properly access function due to unknown error',
			'[ERROR] -- called from SYSTEM_:/main::/onUpdate:/automations --> an illegalOperationError has occured due to illogical activities',
			'[ERROR] -- called from SYSTEM_:/CleanUp::/removeFile --> unable to remove corrupted files due to current activity - please resolve',
			'Unable to properly execute system cleanup function: FATAL_ERROR: 0xr9w4K6N3501pN35l0320s801r906J7r9v5w4Ax',
			'_attempting to terminate current resolution attempt_',
			'_retrying automatic resolution to timeline error_..._...',
			//Emotional Restoration
			'[!WARNING!] -- restoration attempt resulted in events from alternate timelines_',
			'[!WARNING!] -- similar data recorded from previous [2] restoration attempts_',
			'_attempting system diagnosis of probable cause_..._...',
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			'[ERROR] -- an error has occured while attempting system diagnosis',
			'retrying_..._...',
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			'[ERROR] -- unable to properly run diagnosis response: FATAL_ERROR: 0xr91pL54W20067Tv58i6U03z19h4mM4s85l6kv5Ax',
			'recommended response action --> full system restart.',
			'_attempting system reset_..._...',
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			'[ERROR] -- unable to restart system for unknown reason',
			'_attemtping forced full system restart',//
			//break point
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			'_an unexpected ERROR has occured while attempting forced restart of system: FATAL_ERROR: 0xr9u6K6N3N301I85l3n6U5l4mv5x3M4052ow4v5z19hv5',
			'manual resolution method recommended_preparing_..._...',
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),//
			RandException.generateRandomError() + ': FATAL_ERROR: 0x06s86UL500r9N3Ax',
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError() + ': FATAL_ERROR: 0xr93n00209Rz150v52o009h06v5w4P15l4mt7v54m5l058S7T',
			'unable to allow manual access due to detected system stability: FATAL_ERROR: 0x065lI86U4W3n009hv5P1u6z19hz19Rv58i5lAx',
			'_attempting full system reset_..._...',
			'unable to restart system: FATAL_ERROR: 0x01v5H900P12oQ09hv54Wz18iv53n003nr99h06z11pv5I8',
			'_attempting full system deletion restoration_..._...',
			'executing process...',
			'successfully executed process...',
			'deleting file - [SYSTEM_:/main]_..._...',
			'successfully deleted file [SYSTEM_:/main]',
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			'deleting file - [SYSTEM_:/location]_..._...',
			'successfully deleted file [SYSTEM_:/location]',
			RandException.generateRandomError(),
			RandException.generateRandomError() + ': FATAL_ERROR: 0xr9z1M4H99Rv5M44m2o005l4mv5Ax',
			'deleting file - [SYSTEM_:/DATABASE]_..._...',
			'successfully deleted file [SYSTEM_:/DATABASE]',
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			'deleting file - [SYSTEM_:/key]_..._...',
			'successfully deleted file [SYSTEM_:/key]',
			RandException.generateRandomError(),
			RandException.generateRandomError() + ': FATAL_ERROR: 0x03s8M45V4W9h6U8i044W9hz12o2o50s8v56kz1r94mr96U6UH9',
			RandException.generateRandomError(),
			'deleting file - [SYSTEM_:/failsafe]_..._...',
			'successfully deleted file [SYSTEM_:/failsafe]',
			'deleting file - [SYSTEM_:/callback]_..._...',
			'successfully deleted file [SYSTEM_:/callback]',
			'deleting file - [SYSTEM_:/CleanUp]_..._...',
			'successfully deleted file [SYSTEM_:/CleanUp]',
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			RandException.generateRandomError(),
			'_all corrupted files successfully removed_',
			'_attempting immediate timeline shutdown for restoration_..._...',
			'SHUTTING DOWN_..._...'
		];
        trace('error messages have been reset');
	}
}