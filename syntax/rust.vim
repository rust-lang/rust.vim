" Vim syntax file
" Language:     Rust
" Maintainer:   Patrick Walton <pcwalton@mozilla.com>
" Maintainer:   Ben Blum <bblum@cs.cmu.edu>
" Maintainer:   Chris Morgan <me@chrismorgan.info>
" Last Change:  Feb 24, 2016
" For bugs, patches and license go to https://github.com/rust-lang/rust.vim

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Syntax definitions {{{1
" Basic keywords {{{2
syn match     rustNoise "[\[\]]" display nextgroup=rustSigil,rustOperator,@rustIdentifiers skipempty skipwhite
syn match     rustNoise "[.,(]" display nextgroup=@rustIdentifiers skipempty skipwhite
syn match     rustNoise ")" display nextgroup=rustModPath,rustMacro,rustBuiltinType,rustConstant,rustType,rustBoolean,rustSelf,rustFuncName,rustUnused,@rustScopes,rustRawIdent,rustAwait,rustConditional,rustKeyword,rustRepeat,rustStorage,rustUnsafeKeyword,rustOperator,rustIdentifier skipempty skipwhite
syn match     rustNoise ";" display
syn match     rustBounds ":" display nextgroup=rustMacroType,@rustIdentifiers skipempty skipwhite
syn keyword   rustConditional match if else where nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustRepeat continue nextgroup=rustLabel,@rustIdentifiers skipempty skipwhite
syn keyword   rustRepeat in loop while nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustTypedef type nextgroup=rustType skipempty skipwhite
syn keyword   rustStructure struct enum nextgroup=rustType skipempty skipwhite
syn keyword   rustUnion union nextgroup=rustType skipempty skipwhite contained
syn keyword   rustOperator    as nextgroup=@rustIdentifiers skipempty skipwhite
syn match     rustAssert      "\v<assert(\w*)!" contained display
syn match     rustDebugAssert "\v<debug_assert(\w*)!" contained display
syn match     rustPanic       "\v<(panic|todo|unimplemented|unreachable)(\w*)!" contained display
syn keyword   rustAsync       async nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustAwait       await nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustKeyword     break nextgroup=rustLabel,@rustIdentifiers skipempty skipwhite
syn keyword   rustKeyword     box macro
syn keyword   rustKeyword     extern nextgroup=rustExternCrate,rustObsoleteExternMod skipempty skipwhite
syn keyword   rustKeyword     fn nextgroup=rustFuncName skipempty skipwhite
syn keyword   rustKeyword     impl let return yield nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustKeyword     pub nextgroup=rustPubScope,rustTypedef,rustStructure,rustUnion,@rustIdentifiers skipempty skipwhite
syn keyword   rustUnsafeKeyword unsafe
syn keyword   rustInclude     mod use nextgroup=rustModPath skipempty skipwhite
syn match     rustInclude     '\vinclude(_str)?!' skipempty skipwhite
syn keyword   rustKeyword     trait nextgroup=rustType skipempty skipwhite
syn keyword   rustStorage     move mut ref static const nextgroup=@rustIdentifiers skipempty skipwhite
syn match     rustDefault     /\<default\ze\_s\+\(impl\|fn\|type\|const\)\>/ display
syn match     rustKeyword     /\<try\>!\@!/ display

syn match  rustIdentifier "\v<\l(\l|\d)*(_+(\l|\d)*)*>(#)@!" contained display

syn match  rustFuncName   "\v<\w+>(::)?\<" contains=rustModPathSep,rustGenericRegion display
syn match  rustFuncName   "\v<\w+>\s*(\()@=" contains=rustGenericRegion display
syn region rustClosure matchgroup=rustFuncName start="|" end="|" contains=rustNoise,rustBounds,rustSigil,rustGenericRegion,@rustIdentifiers nextgroup=rustNoise,@rustLiterals,@rustIdentifiers skipempty skipwhite

" WARN: since `:syn match` must be used to allow `impl … for` to be
"       highlighted as a `keyword`, it collides with `rustIdentifier`'s
"       definition. Thus is must be placed below it, here, rather than
"       with the other `rustRepeat`s.
syn match     rustRepeat /\<for\>/ display nextgroup=@rustIdentifiers skipempty skipwhite
" WARN: must go after `:syn match rustRepeat` for 'for'
syn match     rustKeyword /\v(<impl>.*\n?\s*)@<=<for>/ nextgroup=@rustIdentifiers skipempty skipwhite

syn match  rustType       "\v<\u(\l|\d)*(\u(\l|\d)*)*>" contains=rustEnum,rustEnumVariant,rustTrait nextgroup=rustModPathSep display

syn match  rustConstant   "\v<\u+(_+(\u|\d)*)*>" display

syn match  rustType       "\v<\u>" nextgroup=rustModPathSep display

syn match  rustUnused "\v<_>" display

syn cluster rustIdentifiers contains=@rustLifetimes,rustMacroVariable,rustMacroRepeat,rustModPath,rustMacro,rustBuiltinType,rustConstant,rustType,rustBoolean,rustSelf,rustFuncName,rustClosure,rustUnused,@rustScopes,rustRawIdent,rustAsync,rustAwait,rustConditional,rustInclude,rustKeyword,rustRepeat,rustStorage,rustUnsafeKeyword,rustIdentifier

syn region rustMacroRepeat matchgroup=rustMacroRepeatDelimiters start="$(" end="\v\)\S{,2}[*+?]" contains=rustMacroVariable
syn match rustMacroVariable "\$\w\+" display nextgroup=rustModPathSep,rustBounds
syn match rustRawIdent "\v<r#(\h\w*)@=" nextgroup=rustFuncName,rustIdentifier display

" Reserved (but not yet used) keywords {{{2
syn keyword   rustReservedKeyword become do priv typeof unsized abstract virtual final override

" Built-in types {{{2
syn keyword   rustBuiltinType isize usize char bool u8 u16 u32 u64 u128 f32 f64 i8 i16 i32 i64 i128 str nextgroup=rustModPathSep
syn keyword   rustMacroType block expr ident item lifetime literal meta pat path stmt tt ty vis contained

" Things from the libstd v1 prelude (src/libstd/prelude/v1.rs) {{{2
" This section is just straight transformation of the contents of the prelude,
" to make it easy to update.

" Reexported core operators {{{3
syn keyword   rustTrait Copy Drop Fn FnMut FnOnce Send Sized Sync contained

" Reexported types and traits {{{3
syn keyword rustEnum Option Result contained
syn keyword rustEnumVariant Ok Err Some None contained
syn keyword rustTrait AsRef AsMut From Into ToOwned Clone Default DoubleEndedIterator ExactSizeIterator Extend Iterator IntoIterator SliceConcatExt PartialEq PartialOrd Eq Ord ToString contained

" Other syntax {{{2
syn keyword   rustSelf    Self nextgroup=rustModPathSep
syn keyword   rustBoolean true false

syn keyword rustSelfScope  self nextgroup=rustModPathSep
syn keyword rustSuperScope super nextgroup=rustModPathSep
syn keyword rustCrateScope crate nextgroup=rustModPathSep
syn cluster rustScopes contains=rustSuperScope,rustSelfScope,rustCrateScope

syn region rustPubScope matchgroup=rustNoise start='(' end=')' contained contains=rustRepeat,@rustScopes,rustModule transparent

syn match   rustModule     "\v(r#)?<\l(\l|\d)*(_+(\l|\d)*)*>" contained contains=rustRawModule,@rustScopes display
syn match   rustModPath    "\v(r#)?<\l(\l|\d)*(_+(\l|\d)*)*>(\s*::(\<)@!)@=" contains=rustModule display nextgroup=rustModPathSep
syn match   rustModPath    "\v\W::(r#)?<\l(\l|\d)*(_+(\l|\d)*)*>" contains=rustModule display nextgroup=rustModPathSep
syn match   rustModPath    "\v((pub\s+)?(use|mod)\s+)@<=(r#)?<\w+>" contains=rustRawModule,rustModule,@rustIdentifiers display nextgroup=rustModPathSep
syn match   rustModPathSep "::" nextgroup=rustModPath,@rustIdentifiers display skipempty skipwhite
syn match   rustRawModule  "\v<r#" contained display nextgroup=rustModule

syn match     rustOperator "\v(/([/*])@!|\^|\&\&?|\|\|?|[<!>%*+=-])" contains=rustArrowCharacter nextgroup=@rustLiterals,@rustIdentifiers skipempty skipwhite
syn match     rustRange "\.\." display nextgroup=rustNoise,@rustLiterals,@rustIdentifiers skipempty skipwhite
syn region    rustGenericRegion matchgroup=rustNoise start="\v\<(\<*\s+|\=)@!" end="\(=\|-\)\@<!>=\@!" contains=rustDynKeyword,@rustLiterals,@rustIdentifiers,@rustComments,rustRange,rustNoise,rustBounds,rustSigil,rustOperator,rustGenericRegion nextgroup=rustClosure,rustModPathSep skipempty skipwhite

syn match     rustSigil /\v[&~*]+[^ &;]@=/ nextgroup=rustDynKeyword,@rustLiterals,@rustIdentifiers skipempty skipwhite
syn match     rustSigil /@/ nextgroup=@rustIdentifiers skipempty skipwhite
syn match     rustArrowCharacter "[-=]>" display
syn match     rustQuestionMark "\v\?(\a+)@!" display

syn match     rustMacro '\w\(\w\)*!' contains=rustAssert,rustCfg,rustDebugAssert,rustInclude,rustPanic
syn match     rustMacro '\v#\w(\w)*'

syn cluster   rustLiterals contains=rustBoolean,rustBinNumber,rustCharacter,rustDecNumber,rustFloat,rustHexNumber,rustOctNumber,rustString
syn match     rustEscapeError   /\\./ contained display
syn match     rustEscape        /\\\([bnrstw0\\'"]\|x\x\{2}\)/ contained display
syn match     rustEscapeUnicode /\\u{\%(\x_*\)\{1,6}}/ contained display

syn match     rustStringContinuation /\\\n\s*/ contained
syn region    rustString matchgroup=rustStringDelimiter start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=rustEscape,rustEscapeError,rustStringContinuation
syn region    rustString matchgroup=rustStringDelimiter start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=rustEscape,rustEscapeUnicode,rustEscapeError,rustStringContinuation,@Spell
syn region    rustString matchgroup=rustStringDelimiter start='b\?r\z(#*\)"' end='"\z1' contains=@Spell

" Match attributes with either arbitrary syntax or special highlighting for
" derives. We still highlight strings and comments inside of the attribute.
syn region    rustAttribute start="#!\?\[" end="\]" contains=@rustAttributeContents,rustAttributeParenthesizedParens,rustAttributeParenthesizedCurly,rustAttributeParenthesizedBrackets,rustDerive,rustCfg nextgroup=@rustTokens skipempty skipwhite
syn region    rustAttributeParenthesizedParens matchgroup=rustNoise start="\v(\w%(\w)*)@<=\("rs=e end=")"re=s transparent contained contains=rustAttributeBalancedParens,@rustAttributeContents,rustOperator
syn region    rustAttributeParenthesizedCurly matchgroup=rustNoise start="\v(\w%(\w)*)@<=\{"rs=e end="}"re=s transparent contained contains=rustAttributeBalancedCurly,@rustAttributeContents,rustOperator
syn region    rustAttributeParenthesizedBrackets matchgroup=rustNoise start="\v(\w%(\w)*)@<=\["rs=e end="\]"re=s transparent contained contains=rustAttributeBalancedBrackets,@rustAttributeContents,rustOperator
syn region    rustAttributeBalancedParens matchgroup=rustNoise start="("rs=e end=")"re=s transparent contained contains=rustAttributeBalancedParens,@rustAttributeContents,rustOperator
syn region    rustAttributeBalancedCurly matchgroup=rustNoise start="{"rs=e end="}"re=s transparent contained contains=rustAttributeBalancedCurly,@rustAttributeContents,rustOperator
syn region    rustAttributeBalancedBrackets matchgroup=rustNoise start="\["rs=e end="\]"re=s transparent contained contains=rustAttributeBalancedBrackets,@rustAttributeContents,rustOperator
syn cluster   rustAttributeContents contains=rustAttributeParenthesizedParens,rustAttributeParenthesizedCurly,rustAttributeParenthesizedBrackets,@rustLiterals,@rustComments,rustCfg,rustDerive
syn match   rustCfg "\vcfg!?" contained
syn keyword rustCfg cfg_attr contained
syn region  rustDerive matchgroup=rustNoise start="\v(derive)@<=\(" end=")" contained contains=rustDeriveTrait,rustType,rustModPath
" This list comes from src/libsyntax/ext/deriving/mod.rs
" Some are deprecated (Encodable, Decodable) or to be removed after a new snapshot (Show).
syn keyword   rustDeriveTrait Clone Hash RustcEncodable RustcDecodable Encodable Decodable PartialEq Eq PartialOrd Ord Rand Show Debug Default FromPrimitive Send Sync Copy contained

" dyn keyword: It's only a keyword when used inside a type expression, so
" we make effort here to highlight it only when Rust identifiers follow it
" (not minding the case of pre-2018 Rust where a path starting with :: can
" follow).
"
" This is so that uses of dyn variable names such as in 'let &dyn = &2'
" and 'let dyn = 2' will not get highlighted as a keyword.
syn match     rustKeyword "\<dyn\ze\_s\+\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)" contains=rustDynKeyword display
syn keyword   rustDynKeyword  dyn contained nextgroup=@rustIdentifier skipempty skipwhite

" Number literals
syn match rustDecNumber "\<\d[0-9_]*\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\=" display
syn match rustHexNumber "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\=" display
syn match rustOctNumber "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\=" display
syn match rustBinNumber "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\=" display

" Special case for numbers of the form "1." which are float literals, unless followed by
" an identifier, which makes them integer literals with a method call or field access,
" or by another ".", which makes them integer literals followed by the ".." token.
" (This must go first so the others take precedence.)
syn match     rustFloat "\<\d[0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!" display
" To mark a number as a normal float, it must have at least one of the three things integral values don't have:
" a decimal point and more numbers; an exponent; and a type suffix.
syn match     rustFloat "\<\d[0-9_]*\%(\.\d[0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\=" display
syn match     rustFloat "\<\d[0-9_]*\%(\.\d[0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\=" display
syn match     rustFloat "\<\d[0-9_]*\%(\.\d[0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)" display

"rustLifetime must appear before rustCharacter, or chars will get the lifetime highlighting
syn match     rustLifetime "\v'\w+(')@!" display nextgroup=rustNoise,rustDynKeyword,@rustIdentifiers skipempty skipwhite
syn match     rustStaticLifetime "'static\>" display nextgroup=rustNoise,rustDynKeyword,@rustIdentifiers skipempty skipwhite
syn cluster   rustLifetimes contains=rustStaticLifetime,rustLifetime
syn match     rustLabel "\v'\w+" nextgroup=rustBounds display
syn match     rustLabel "\v'\w+"  contained display

syn match   rustCharacterDelimiter "'" contained
syn match   rustCharacterInvalid /b\?'\zs[\n\r\t']\ze'/ contained
" The groups negated here add up to 0-255 but nothing else (they do not seem to go beyond ASCII).
syn match   rustCharacterInvalidUnicode /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/ contained display
syn match   rustCharacter /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=rustEscape,rustEscapeError,rustCharacterDelimiter,rustCharacterInvalid,rustCharacterInvalidUnicode
syn match   rustCharacter /'\([^\\]\|\\\(.\|x\x\{2}\|u{\%(\x_*\)\{1,6}}\)\)'/ contains=rustEscape,rustEscapeUnicode,rustEscapeError,rustCharacterDelimiter,rustCharacterInvalid

syn match rustShebang /\%^#![^[].*/ display

" FIXME: this is a really ugly and not fully correct implementation. Most
" importantly, a case like ``/* */*`` should have the final ``*`` not being in
" a comment, but in practice at present it leaves comments open two levels
" deep. But as long as you stay away from that particular case, I *believe*
" the highlighting is correct. Due to the way Vim's syntax engine works
" (greedy for start matches, unlike Rust's tokeniser which is searching for
" the earliest-starting match, start or end), I believe this cannot be solved.
" Oh you who would fix it, don't bother with things like duplicating the Block
" rules and putting ``\*\@<!`` at the start of them; it makes it worse, as
" then you must deal with cases like ``/*/**/*/``. And don't try making it
" worse with ``\%(/\@<!\*\)\@<!``, either...
syn region rustCommentLine                                                  start="//"                      end="$"   contains=rustTodo,@Spell nextgroup=@rustTokens skipempty skipwhite
syn region rustCommentLineDoc                                               start="//\%(//\@!\|!\)"         end="$"   contains=rustTodo,@Spell nextgroup=@rustTokens skipempty skipwhite
syn region rustCommentBlock             matchgroup=rustCommentBlock         start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=rustTodo,rustCommentBlockNest,@Spell nextgroup=@rustTokens skipempty skipwhite
syn region rustCommentBlockDoc          matchgroup=rustCommentBlockDoc      start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=rustTodo,rustCommentBlockDocNest,rustCommentBlockDocRustCode,@Spell nextgroup=@rustTokens skipempty skipwhite
syn region rustCommentBlockNest         matchgroup=rustCommentBlock         start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockNest,@Spell contained transparent
syn region rustCommentBlockDocNest      matchgroup=rustCommentBlockDoc      start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockDocNest,@Spell contained transparent

syn cluster rustComments contains=rustCommentBlock,rustCommentBlockDoc,rustCommentLine,rustCommentLineDoc

syn keyword rustTodo contained TODO FIXME XXX NB NOTE SAFETY

" asm! macro {{{2
syn region rustAsmMacro matchgroup=rustMacro start="\<asm!\s*(" end=")" contains=rustAsmDirSpec,rustAsmSym,rustAsmConst,rustAsmOptionsKey,@rustComments,rustString

" Clobbered registers
syn keyword rustAsmDirSpec in out lateout inout inlateout contained nextgroup=rustAsmReg skipempty skipwhite
syn region  rustAsmReg matchgroup=rustNoise start="(" end=")" contained contains=rustString

" Symbol operands
syn keyword rustAsmSym sym contained nextgroup=rustAsmSymPath skipempty skipwhite
syn region  rustAsmSymPath start="\S" end=",\|)"me=s-1 contained contains=@rustComments,rustType

" Const
syn region  rustAsmConstBalancedParens start="("ms=s+1 end=")" contained contains=@rustAsmConstExpr
syn cluster rustAsmConstExpr contains=@rustComments,@rustLiterals,rustAsmConstBalancedParens
syn region  rustAsmConst start="const" end=",\|)"me=s-1 contained contains=rustStorage,@rustAsmConstExpr

" Options
syn region  rustAsmOptionsGroup matchgroup=rustNoise start="\v(options)@<=\s*\(" end=")" contained contains=rustAsmOptionsKey,rustAsmOptions
syn keyword rustAsmOptionsKey options contained nextgroup=rustAsmOptionsGroup
syn keyword rustAsmOptions pure nomem readonly preserves_flags noreturn nostack att_syntax contained

" Folding rules {{{2
" Trivial folding rules to begin with.
" FIXME: use the AST to make really good folding
syn region rustFoldBraces matchgroup=rustNoise start="{" end="}" contains=rustFoldBraces,rustAttribute,@rustComments,@rustTokens transparent fold

if !exists("b:current_syntax_embed")
    let b:current_syntax_embed = 1
    syntax include @RustCodeInComment <sfile>:p:h/rust.vim
    unlet b:current_syntax_embed

    " Currently regions marked as ```<some-other-syntax> will not get
    " highlighted at all. In the future, we can do as vim-markdown does and
    " highlight with the other syntax. But for now, let's make sure we find
    " the closing block marker, because the rules below won't catch it.
    syn region rustCommentLinesDocNonRustCode matchgroup=rustCommentDocCodeFence start='^\z(\s*//[!/]\s*```\).\+$' end='^\z1$' keepend contains=rustCommentLineDoc

    " We borrow the rules from rust’s src/librustdoc/html/markdown.rs, so that
    " we only highlight as Rust what it would perceive as Rust (almost; it’s
    " possible to trick it if you try hard, and indented code blocks aren’t
    " supported because Markdown is a menace to parse and only mad dogs and
    " Englishmen would try to handle that case correctly in this syntax file).
    syn region rustCommentLinesDocRustCode matchgroup=rustCommentDocCodeFence start='^\z(\s*//[!/]\s*```\)[^A-Za-z0-9_-]*\%(\%(should_panic\|no_run\|ignore\|allow_fail\|rust\|test_harness\|compile_fail\|E\d\{4}\|edition201[58]\)\%([^A-Za-z0-9_-]\+\|$\)\)*$' end='^\z1$' keepend contains=@RustCodeInComment,rustCommentLineDocLeader
    syn region rustCommentBlockDocRustCode matchgroup=rustCommentDocCodeFence start='^\z(\%(\s*\*\)\?\s*```\)[^A-Za-z0-9_-]*\%(\%(should_panic\|no_run\|ignore\|allow_fail\|rust\|test_harness\|compile_fail\|E\d\{4}\|edition201[58]\)\%([^A-Za-z0-9_-]\+\|$\)\)*$' end='^\z1$' keepend contains=@RustCodeInComment,rustCommentBlockDocStar
    " Strictly, this may or may not be correct; this code, for example, would
    " mishighlight:
    "
    "     /**
    "     ```rust
    "     println!("{}", 1
    "     * 1);
    "     ```
    "     */
    "
    " … but I don’t care. Balance of probability, and all that.
    syn match rustCommentBlockDocStar /^\s*\*\s\?/ contained
    syn match rustCommentLineDocLeader "^\s*//\%(//\@!\|!\)" contained
endif

syn cluster rustTokens contains=rustStructure,rustTypedef,rustDynKeyword,rustUnion,@rustLiterals,@rustIdentifiers,rustLabel,rustRange,rustNoise,rustBounds,rustArrowCharacter,rustSigil,rustOperator,rustQuestionMark,rustGenericRegion

" Default highlighting {{{1

" Asm {{{2
hi def link rustAsmDirSpec    rustOperator
hi def link rustAsmOptions    rustStorage
hi def link rustAsmOptionsKey rustAttribute
hi def link rustAsmReg        rustStorage
hi def link rustAsmSym        rustAsmDirSpec

" Comments {{{2
hi def link rustCommentBlock         rustCommentLine
hi def link rustCommentBlockDoc      rustCommentLineDoc
hi def link rustCommentBlockDocStar  rustCommentBlockDoc
hi def link rustCommentDocCodeFence  rustCommentLineDoc
hi def link rustCommentLine          Comment
hi def link rustCommentLineDoc       SpecialComment
hi def link rustCommentLineDocLeader rustCommentLineDoc
hi def link rustTodo Todo

" Identifiers {{{2
hi def link rustBuiltinType    Type
hi def link rustConstant       Constant
hi def link rustDeriveTrait    rustTrait
hi def link rustEnum           rustBuiltinType
hi def link rustEnumVariant    Constant
hi def link rustFuncName       Function
hi def link rustIdentifier     Normal " NOTE: this should be `Identifier`, but some colorschemes look too busy that way.
hi def link rustLabel          Label
hi def link rustLifetime       rustLabel
hi def link rustMacro          Macro
hi def link rustMacroRepeatDelimiters Special
hi def link rustMacroType      rustBuiltinType
hi def link rustMacroVariable  Define
hi def link rustModPathSep     rustNoise
hi def link rustModule         Directory
hi def link rustRawIdent       Special
hi def link rustRawModule      rustRawIdent
hi def link rustRawString      rustRawIdent
hi def link rustStaticLifetime rustStorage
hi def link rustTrait          rustBuiltinType
hi def link rustType           Type
hi def link rustUnused         Special

" Keywords {{{2
hi def link rustAssert          PreCondit
hi def link rustAsync           rustKeyword
hi def link rustAwait           rustAsync
hi def link rustConditional     Conditional
hi def link rustCrateScope      rustKeyword
hi def link rustDebugAssert     Debug
hi def link rustDefault         rustKeyword
hi def link rustDynKeyword      rustStorage
hi def link rustInclude         Include
hi def link rustKeyword         Keyword
hi def link rustPanic           Exception
hi def link rustRepeat          Repeat
hi def link rustReservedKeyword Error
hi def link rustSelf            Typedef
hi def link rustSelfScope       rustKeyword
hi def link rustStructure       Keyword
hi def link rustSuperScope      rustKeyword
hi def link rustTypedef         Keyword
hi def link rustUnion           rustStructure
hi def link rustUnsafeKeyword   Exception

" Literals {{{2
hi def link rustBinNumber     rustNumber
hi def link rustBoolean       Boolean
hi def link rustCharacter     Character
hi def link rustCharacterDelimiter rustCharacter
hi def link rustCharacterInvalid Error
hi def link rustCharacterInvalidUnicode rustCharacterInvalid
hi def link rustDecNumber     rustNumber
hi def link rustEscape        SpecialChar
hi def link rustEscapeError   Error
hi def link rustEscapeUnicode rustEscape
hi def link rustFloat         Float
hi def link rustHexNumber     rustNumber
hi def link rustNumber        Number
hi def link rustOctNumber     rustNumber
hi def link rustString        String
hi def link rustStringContinuation SpecialChar
hi def link rustStringDelimiter rustString

" Preprocessing {{{2
hi def link rustAttribute PreProc
hi def link rustCfg       PreCondit
hi def link rustDerive    PreProc
hi def link rustShebang   Comment

" Symbols {{{2
hi def link rustArrowCharacter rustBounds
hi def link rustBounds         rustOperator
hi def link rustGeneric        rustNoise
hi def link rustNoise          Delimiter
hi def link rustOperator       Operator
hi def link rustQuestionMark   Exception
hi def link rustRange          rustOperator
hi def link rustSigil          rustStorage
hi def link rustStorage        StorageClass

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "rust"

" vim: set et sw=4 sts=4 ts=8:
