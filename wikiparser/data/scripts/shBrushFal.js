SyntaxHighlighter.brushes.Falcon = function()
{
	// Contributed by Kibleur Christophe.
	
	var keywords =	'dropping return launch from global const self sender catch raise ' +
	        'give case default pass lambda def directive load export enum ' +
	        'try switch select object print printl ';
	        
	var entities = 'class function macro innerfunc init static '
	        
	var kw = 'while loop for forfirst formiddle forlast end if elif else if break continue';

	var builtins =	'and or not in notin to as has hasnt provides nil Error TraceStep ' +
	                'SyntaxError CodeError RangeError MathError IoError TypeError ' +
	                'ParamError ParseError CloneError InterruptedError List all any ' +
	                'allp anyp eval choice xmap iff lit cascade dolist eq ' +
	                'bless ' ;
	                
	var falTypes = 'NilType IntegerType NumericType RangeType MemBufType ' +
                    'FunctionType StringType ArrayType DictionaryType ObjectType ClassType ' +
                    'MethodType ExtMethodType ClassMethodType LibFuncType OpaqueType ' ;
	                
	this.regexList = [
		{ regex: /^#!(.*)/g,                                 css: 'comments' },                          // string
		{ regex: /\+\+|\+|\-|\*|\.|\^|:|\[|\]|\%|==|&gt;|\=&lt;|&lt;|=|\{|\}|\(|\)|,/gm, css: 'operator' }, // operators
		{ regex: SyntaxHighlighter.regexLib.singleLineCComments,css: 'comments' },	                        // one line comments
		{ regex: SyntaxHighlighter.regexLib.multiLineCComments,	css: 'comments' },			                // multiline comments
		{ regex: /"(?:\.|(\\\")|[^\"])*"/gm,                    css: 'string' },                            // string
		{ regex: /'(?:\.|(\\\')|[^\'])*'/gm,                    css: 'string1' },                           // string1
		{ regex: /\b[A-Z0-9_]+\b/g,								css: 'constants' },                         // constants
		{ regex: /:[a-z][A-Za-z0-9_]*/g,						css: 'color2' },                            // symbols
		{ regex: new RegExp(this.getKeywords(keywords), 'gm'),	css: 'keyword' },                           // keywords
		{ regex: new RegExp(this.getKeywords(kw), 'gm'),		css: 'value' },	                            // keyword
		{ regex: new RegExp(this.getKeywords(entities), 'gm'),	css: 'preprocessor' },                      // entities
		{ regex: new RegExp(this.getKeywords(builtins), 'gm'),	css: 'color1' },                            // builtins
		{ regex: new RegExp(this.getKeywords(falTypes), 'gm'),	css: 'color2' },                            // falconType
		];

	this.forHtmlScript(SyntaxHighlighter.regexLib.aspScriptTags);
};

SyntaxHighlighter.brushes.Falcon.prototype	= new SyntaxHighlighter.Highlighter();
SyntaxHighlighter.brushes.Falcon.aliases		= [ 'fas', 'fal', 'falcon'];
