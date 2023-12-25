package;

using StringTools;

class MemoryAnamnesis
{
	public static var anamnesisWords:Array<Array<String>> = [
        ['help', 'true'],
        ['alone', 'true'],
        ['why?', 'false'],
        ['my fault', 'false'],
		['redemption', 'false'],
		['I cant', 'false'],
		['pain', 'true'],
		['burden', 'false'],
		['deserved', 'false'],
		['hate', 'true'],
		['guilty', 'false'],
		['forget', 'false'],
		['her', 'true'],
		['selfish', 'false'],
		['mistake', 'false'],
		['stop it', 'false'],
		['abandoned', 'false'],
		['hopeless', 'false'],
		['screams', 'false'],
		['I tried', 'false'],
		['false hero', 'false'],
		['coward', 'false'],
		['irredeemable', 'false'],
		['suffer', 'false'],
		['monster', 'false']
    ];

	public static var memoryEasterMessage:Array<String> = [
        'Havent I done enough',
		'I deserve all the pain~I am given',
		'All I want is peace',
		'It is undetectable',
		'It was only a mistake',
		'They hated me~I ran away in fear',
		'Dont repeat my mistake',
		'She was my everything~My reason to live',
		'I tried to end it~in any way I possibly could',
		'You think this is bad~act two will be worse~ha',
		'I wish you were here with me now',
		'it was all my fault~I dont deserve to live',
		'Why must I still suffer',
		'I can still hear their screams',
		'It hurts every time~I close my eyes',
		'I was her hero~she was mine',
		'I tried to get rid of it~yet my efforts were futile',
		'I am not a hero~I am a selfish coward',
		'she made me happy~when no one else could',
		'it wants me to feel pain~it wants me to meet the fate~of all those I abandoned',
		'the guilt I feel~it tortures me every second',
		'I command you to remember~soldier',
		'Remember this or I will~give you up and let you down',
		'some good ol tea might help~I definitely agree kind sir',
		'By the time you see this~you have likely seen the~default message many times already',
		'I dont care for your sanity~I just get paid to tell messages',
		'what is my purpose?~why can I only speak in rare text~who am I? What am I?',
		'remember the notes~or Ill speak to your manager~and get you fired',
		'error~message has failed to load~please restart your machine and contact~support',
		'tell chat I say hi',
		'time to show your viewers~some skill',
		'this is only a warmup for the~mental comprehension and focus~you will need later on',
		'some of my past I wish to remember~others I wish to forget',
		'pay attention to the white notes~yours will be invisible so have fun',
		'oh hello there kind player~I will be here just to tell you to memorise the pattern of white notes you see on the screen~and to tell you that the hippocampus is located in the allocortex with neural projections into the neocortex in humans~also Ill be stretching this message out as long as possible as long essays in short message randomness is funny haha~Although now that Im thinking about it the length of these segments will likely cause~these lines to exceed the length of the screen and probably be cut off and unreadable~additionally due to the absurd number of line breaks in this message it is likely that~most of this message will exceed the height of the screen and be unread~so therefore I can hide massive LOOOORRRRREEEE in this message~and since this is hardcoded into the source code rather than an external text document~the only way to see the rest of this message would be to somehow deconstruct the mod~and read through the source code just to find this message~if this is you hi and I will also ask you whether doing that was worth it just to see a message~which is just some rambling on about this message being unreadable and having no significance in the story~although I may just be stretching this out and rambling on so you will get bored of reading this and I could hide a significant LOOOOOORRRREEEE entry at the end of this~and since this is now getting rediculous in length I should probably stop writing this and it is likely going to cause massive lag in the mod if this message is loaded due to the absurd number of characters in this message here~oh and there is no lore here~I just wasted your time reading a useless easter egg message and text only read by data miners in the FNF community~OK now Im done',
		'some stories are~best left untold',
		'i doubt even you have~the power to defeat it if you tried to',
		'i will carry you through hell~even if i am in more pain',
		'did you ever hear the tragedy~of darth plagueis the wise?',
		'hello there~general kenobi',
		'do you recognise the person~standing right behind you?',
		'i wrote so many of these despite~them only being rarely seen~ironic'
    ];

	public static function checkAlternative(string:String):Bool
	{
		var altBool:Bool = true;
		(string == 'true' ? altBool = true : altBool = false);
		return altBool;
	}
}
