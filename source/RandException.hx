package;

import flixel.FlxG;

using StringTools;

class RandException
{
	static var wordArray:Array<Array<String>> = [
		[
			'SYSTEM_', 'file', 'main', 'global_', 'timelineManager', 'dimensionalManager', 'positionalManager', 'callbackManager', 'core', 'globalNanoManager',
			'globalSensoryManager', 'personManager', 'publicSystem', 'USER_'
		],
		[
			'DATABASE', 'failsafe', 'onCurrent', 'keyManager', 'callbackResponse', 'neuroSystems', 'systemBind_', '_onUpdate', 'enumeration',
			'lifeSignalResponse', 'auto_Responses', 'onNanoError', 'sensorInput', 'loadingState', 'locationResponseCallback'
		],
		[
			'illegalOperationError',
			'systemCoreError',
			'propertyMappingError',
			'argumentError',
			'exceptionError',
			'logicError',
			'runtimeError',
			'viralCriticalExceptionError',
			'integrationError',
			'boundExceptionTypeError',
			'expectedInputError',
			'invalidActivityError',
			'codeBinaryError',
			'processExtensionError',
			'exceptionWrapperError',
			'initialisationError',
			'illogicalUserInputError'
		]
	];

	static var outputResponse_:String = '';

	public static function generateRandomError():String
	{
		outputResponse_ = '[ERROR] -- called from ';
		outputResponse_ += wordArray[0][FlxG.random.int(0, wordArray[0].length - 1)]
			+ ':/'
			+ wordArray[1][FlxG.random.int(0, wordArray[1].length - 1)] + ' --> ' + wordArray[2][FlxG.random.int(0, wordArray[2].length - 1)];
		return outputResponse_;
	}
}
