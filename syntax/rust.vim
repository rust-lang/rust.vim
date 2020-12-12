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
syn match     rustNoise "[,\.\[\]()]" display nextgroup=rustNoise,rustKeyword,rustStorage,@rustLiterals,@rustIdentifiers skipempty skipwhite
syn match     rustNoise ";" display
syn match     rustBounds ":" display nextgroup=rustKeyword,rustStorage,@rustIdentifiers skipempty skipwhite
syn keyword   rustConditional match if else nextgroup=rustConditional,@rustIdentifiers skipempty skipwhite
syn keyword   rustRepeat loop while nextgroup=@rustIdentifiers skipempty skipwhite
" `:syn match` must be used to prioritize highlighting `for` keyword.
syn match     rustRepeat /\<for\>/ display nextgroup=@rustIdentifiers skipempty skipwhite
" Highlight `for` keyword in `impl ... for ... {}` statement. This line must
" be put after previous `syn match` line to overwrite it.
syn match     rustKeyword /\%(\<impl\>.\+\)\@<=\<for\>/ display nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustRepeat in nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustTypedef type nextgroup=rustType skipempty skipwhite
syn keyword   rustStructure struct enum nextgroup=rustType skipempty skipwhite
syn match     rustFieldName "\(pub \)\?\w\+" contained contains=rustKeyword display nextgroup=rustNoise skipempty skipwhite
syn region    rustStructDefinition matchgroup=rustNoise start="\(\<struct\>.*\n\?\)\@<={" end="}" contains=rustCommentBlock,rustCommentBlockDoc,rustCommentLineDoc,rustCommentLine,rustFieldName,rustGenericRegion,rustLifetime,rustModPathSep,rustNoise,rustBounds,rustSigil,rustBuiltinType transparent fold
syn keyword   rustUnion union nextgroup=rustType skipempty skipwhite contained
syn match rustUnionContextual /\<union\_s\+\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*/ transparent contains=rustUnion
syn keyword   rustOperator    as nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustExistential existential nextgroup=rustTypedef skipempty skipwhite contained
syn match rustExistentialContextual /\<existential\_s\+type/ display transparent contains=rustExistential,rustTypedef

syn match     rustAssert      "\<assert\(\w\)*!" contained display
syn match     rustPanic       "\<panic\(\w\)*!" contained display
syn match     rustAsync       "\<async\%(\s\|\n\)\@="
syn keyword   rustKeyword     break nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustKeyword     box
syn keyword   rustKeyword     continue nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustKeyword     crate
syn keyword   rustKeyword     extern nextgroup=rustExternCrate,rustObsoleteExternMod skipempty skipwhite
syn keyword   rustKeyword     fn nextgroup=rustFuncName skipempty skipwhite
syn keyword   rustKeyword     impl nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustKeyword     let nextgroup=rustStorage,@rustIdentifiers skipempty skipwhite
syn keyword   rustKeyword     macro
syn keyword   rustKeyword     pub nextgroup=rustPubScope skipempty skipwhite
syn keyword   rustKeyword     return nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustKeyword     yield nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustSuper       super
syn keyword   rustKeyword     where nextgroup=@rustIdentifiers skipempty skipwhite
syn keyword   rustUnsafeKeyword unsafe
syn keyword   rustKeyword     use nextgroup=rustModPath skipempty skipwhite
" FIXME: Scoped impl's name is also fallen in this category
syn keyword   rustKeyword     mod trait nextgroup=rustType skipempty skipwhite
syn keyword   rustStorage     move mut ref static const nextgroup=@rustIdentifiers skipempty skipwhite
syn match     rustDefault     /\<default\ze\_s\+\(impl\|fn\|type\|const\)\>/ display
syn keyword   rustAwait       await nextgroup=@rustIdentifiers skipempty skipwhite
syn match     rustKeyword     /\<try\>!\@!/ display

syn keyword rustPubScopeCrate crate contained
syn match rustPubScope /([^()]*)/ contained contains=rustNoise,rustPubScopeCrate,rustSuper,rustModPath,rustModPathSep,rustSelf display transparent

syn keyword   rustExternCrate crate contained nextgroup=rustType,rustExternCrateString skipempty skipwhite
" This is to get the `bar` part of `extern crate "foo" as bar;` highlighting.
syn match   rustExternCrateString /".*"\_s*as/ contained display nextgroup=rustType skipwhite transparent skipempty contains=rustString,rustOperator
syn keyword   rustObsoleteExternMod mod contained nextgroup=rustType skipempty skipwhite

syn match  rustIdentifier "\<\l\+\(_\l\+\)*\((\)\@!\>" contained contains=rustBoolean,rustSelf display
syn match  rustType       "\<\(\u\l*\)\+\((\)\@!\>" contains=rustTypePrime contained display
syn match  rustConstant   "\<\u\+\(_\u\+\)*\((\)\@!\>" contained display
syn match  rustFuncName   "\<\w\+\(::\)\?\(<.*>\)\?\s*\((\)\@=\>" contains=rustEnumVariant,rustModPathSep,rustGenericRegion display
syn cluster rustIdentifiers contains=rustLifetime,rustModPath,rustBuiltinType,rustEnum,rustTrait,rustEnumVariant,rustMacro,rustFuncName,rustConstant,rustIdentifier,rustType

syn region rustMacroRepeat matchgroup=rustMacroRepeatDelimiters start="$(" end="),\=[*+]" contains=TOP
syn match rustMacroVariable "\$\w\+" display
syn match rustRawIdent "\<r#\h\w*" contains=NONE display

" Reserved (but not yet used) keywords {{{2
syn keyword   rustReservedKeyword become do priv typeof unsized abstract virtual final override

" Built-in types {{{2
syn keyword   rustBuiltinType        isize usize char bool u8 u16 u32 u64 u128 f32
syn keyword   rustBuiltinType        error env thread
syn keyword   rustBuiltinType        f64 i8 i16 i32 i64 i128 str Self

" Things from the libstd v1 prelude (src/libstd/prelude/v1.rs) {{{2
" This section is just straight transformation of the contents of the prelude,
" to make it easy to update.

" Reexported core operators {{{3
syn keyword   rustTrait       Copy Send Sized Sync
syn keyword   rustTrait       Drop Fn FnMut FnOnce

" Reexported functions {{{3
" There’s no point in highlighting these; when one writes drop( or drop::< it
" gets the same highlighting anyway, and if someone writes `let drop = …;` we
" don’t really want *that* drop to be highlighted.
"syn keyword rustFunction drop

" Reexported types and traits {{{3
syn keyword rustTrait Box
syn keyword rustTrait ToOwned
syn keyword rustTrait Clone
syn keyword rustTrait PartialEq PartialOrd Eq Ord
syn keyword rustTrait AsRef AsMut Into From
syn keyword rustTrait Default
syn keyword rustTrait Iterator Extend IntoIterator
syn keyword rustTrait DoubleEndedIterator ExactSizeIterator
syn keyword rustEnum Option
syn keyword rustEnumVariant Some None
syn keyword rustEnum Result
syn keyword rustEnumVariant Ok Err
syn keyword rustTrait SliceConcatExt
syn keyword rustTrait String ToString
syn keyword rustTrait Vec

" Other syntax {{{2
syn keyword   rustSelf        self
syn keyword   rustBoolean     true false

" If foo::bar changes to foo.bar, change this ("::" to "\.").
" If foo::bar changes to Foo::bar, change this (first "\w" to "\u").
syn match     rustModPath     "\w\(\w\)*::\(<\)\@!"he=e-2,me=e-2 nextgroup=rustModPathSep contains=rustSelf display
syn match     rustModPathSep  "::" nextgroup=@rustIdentifiers skipempty skipwhite display
syn region    rustFoldModPath matchgroup=rustNoise start="\(::\s*\n*\)\@<={" end="}" contains=rustCommentBlock,rustCommentBlockDoc,rustCommentLineDoc,rustCommentLine,@rustIdentifiers,rustNoise transparent fold

" This is merely a convention; note also the use of [A-Z], restricting it to
" latin identifiers rather than the full Unicode uppercase. I have not used
" [:upper:] as it depends upon 'noignorecase'
"syn match     rustCapsIdent    display "[A-Z]\w\(\w\)*"

syn match     rustOperator     "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\| [<>]\|%\)=\?" display nextgroup=@rustLiterals,@rustIdentifiers skipempty skipwhite
syn region    rustGenericRegion matchgroup=rustNoise start="\(\s\+\|=\)\@<!<" end="\(=\|-\)\@<!>" contains=rustNoise,rustBounds,rustGenericRegion,@rustIdentifiers
" This one isn't *quite* right, as we could have binary-& with a reference
syn match     rustSigil /&\s\+[&~@*][^)= \t\r\n]/he=e-1,me=e-1 nextgroup=rustStorage,@rustIdentifiers skipempty skipwhite
syn match     rustSigil /[&~@*][^)= \t\r\n]/he=e-1,me=e-1 nextgroup=rustStorage,@rustIdentifiers skipempty skipwhite
" This isn't actually correct; a closure with no arguments can be `|| { }`.
" Last, because the & in && isn't a sigil
syn match     rustOperator  "&&\|||" display nextgroup=rustBoolean,@rustIdentifiers skipempty skipwhite
" This is rustArrowCharacter rather than rustArrow for the sake of matchparen,
" so it skips the ->; see http://stackoverflow.com/a/30309949 for details.
syn match     rustArrowCharacter "->" display nextgroup=@rustIdentifiers skipempty skipwhite
syn match     rustArrowCharacter "=>" display
syn match     rustQuestionMark "?\([a-zA-Z]\+\)\@!" display

syn match     rustMacro '\w\(\w\)*!' contains=rustAssert,rustPanic
syn match     rustMacro '#\w\(\w\)*' contains=rustAssert,rustPanic

syn cluster   rustLiterals contains=rustDecNumber,rustHexNumber,rustOctNumber,rustBinNumber,rustCharacter,rustString,rustFloat
syn match     rustEscapeError   /\\./ contained display
syn match     rustEscape        /\\\([bnrstw0\\'"]\|x\x\{2}\)/ contained display
syn match     rustEscapeUnicode /\\u{\%(\x_*\)\{1,6}}/ contained display
syn match     rustStringContinuation /\\\n\s*/ contained
syn region    rustString matchgroup=rustStringDelimiter start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=rustEscape,rustEscapeError,rustStringContinuation
syn region    rustString matchgroup=rustStringDelimiter start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=rustEscape,rustEscapeUnicode,rustEscapeError,rustStringContinuation,@Spell
syn region    rustString matchgroup=rustStringDelimiter start='b\?r\z(#*\)"' end='"\z1' contains=@Spell

" Match attributes with either arbitrary syntax or special highlighting for
" derives. We still highlight strings and comments inside of the attribute.
syn region    rustAttribute   start="#!\?\[" end="\]" contains=@rustAttributeContents,rustAttributeParenthesizedParens,rustAttributeParenthesizedCurly,rustAttributeParenthesizedBrackets,rustDerive
syn region    rustAttributeParenthesizedParens matchgroup=rustAttribute start="\w\%(\w\)*("rs=e end=")"re=s transparent contained contains=rustAttributeBalancedParens,@rustAttributeContents
syn region    rustAttributeParenthesizedCurly matchgroup=rustAttribute start="\w\%(\w\)*{"rs=e end="}"re=s transparent contained contains=rustAttributeBalancedCurly,@rustAttributeContents
syn region    rustAttributeParenthesizedBrackets matchgroup=rustAttribute start="\w\%(\w\)*\["rs=e end="\]"re=s transparent contained contains=rustAttributeBalancedBrackets,@rustAttributeContents
syn region    rustAttributeBalancedParens matchgroup=rustAttribute start="("rs=e end=")"re=s transparent contained contains=rustAttributeBalancedParens,@rustAttributeContents
syn region    rustAttributeBalancedCurly matchgroup=rustAttribute start="{"rs=e end="}"re=s transparent contained contains=rustAttributeBalancedCurly,@rustAttributeContents
syn region    rustAttributeBalancedBrackets matchgroup=rustAttribute start="\["rs=e end="\]"re=s transparent contained contains=rustAttributeBalancedBrackets,@rustAttributeContents
syn cluster   rustAttributeContents contains=rustString,rustCommentLine,rustCommentBlock,rustCommentLineDocError,rustCommentBlockDocError
syn region    rustDerive      start="derive(" end=")" contained contains=rustDeriveTrait
" This list comes from src/libsyntax/ext/deriving/mod.rs
" Some are deprecated (Encodable, Decodable) or to be removed after a new snapshot (Show).
syn keyword   rustDeriveTrait contained Clone Hash RustcEncodable RustcDecodable Encodable Decodable PartialEq Eq PartialOrd Ord Rand Show Debug Default FromPrimitive Send Sync Copy

" dyn keyword: It's only a keyword when used inside a type expression, so
" we make effort here to highlight it only when Rust identifiers follow it
" (not minding the case of pre-2018 Rust where a path starting with :: can
" follow).
"
" This is so that uses of dyn variable names such as in 'let &dyn = &2'
" and 'let dyn = 2' will not get highlighted as a keyword.
syn match     rustKeyword "\<dyn\ze\_s\+\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)" contains=rustDynKeyword display
syn keyword   rustDynKeyword  dyn contained

" Number literals
syn match rustDecNumber "\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\=" display
syn match rustHexNumber "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\=" display
syn match rustOctNumber "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\=" display
syn match rustBinNumber "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\=" display

" Special case for numbers of the form "1." which are float literals, unless followed by
" an identifier, which makes them integer literals with a method call or field access,
" or by another ".", which makes them integer literals followed by the ".." token.
" (This must go first so the others take precedence.)
syn match     rustFloat "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!" display
" To mark a number as a normal float, it must have at least one of the three things integral values don't have:
" a decimal point and more numbers; an exponent; and a type suffix.
syn match     rustFloat "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\=" display
syn match     rustFloat "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\=" display
syn match     rustFloat "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)" display

"rustLifetime must appear before rustCharacter, or chars will get the lifetime highlighting
syn match     rustLifetime "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display nextgroup=rustNoise,@rustIdentifiers skipempty skipwhite
syn match     rustLabel "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*:" display
syn match     rustLabel "\%(\<\%(break\|continue\)\s*\)\@<=\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display
syn match   rustCharacterInvalid /b\?'\zs[\n\r\t']\ze'/ contained
" The groups negated here add up to 0-255 but nothing else (they do not seem to go beyond ASCII).
syn match   rustCharacterInvalidUnicode /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/ contained display
syn match   rustCharacter /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=rustEscape,rustEscapeError,rustCharacterInvalid,rustCharacterInvalidUnicode
syn match   rustCharacter /'\([^\\]\|\\\(.\|x\x\{2}\|u{\%(\x_*\)\{1,6}}\)\)'/ contains=rustEscape,rustEscapeUnicode,rustEscapeError,rustCharacterInvalid

syn match rustShebang /\%^#![^[].*/ display
syn region rustCommentLine                                                  start="//"                      end="$"   contains=rustTodo,@Spell
syn region rustCommentLineDoc                                               start="//\%(//\@!\|!\)"         end="$"   contains=rustTodo,@Spell
syn region rustCommentLineDocError                                          start="//\%(//\@!\|!\)"         end="$"   contains=rustTodo,@Spell contained
syn region rustCommentBlock             matchgroup=rustCommentBlock         start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=rustTodo,rustCommentBlockNest,@Spell
syn region rustCommentBlockDoc          matchgroup=rustCommentBlockDoc      start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=rustTodo,rustCommentBlockDocNest,rustCommentBlockDocRustCode,@Spell
syn region rustCommentBlockDocError     matchgroup=rustCommentBlockDocError start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=rustTodo,rustCommentBlockDocNestError,@Spell contained
syn region rustCommentBlockNest         matchgroup=rustCommentBlock         start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockNest,@Spell contained transparent
syn region rustCommentBlockDocNest      matchgroup=rustCommentBlockDoc      start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockDocNest,@Spell contained transparent
syn region rustCommentBlockDocNestError matchgroup=rustCommentBlockDocError start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockDocNestError,@Spell contained transparent

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

syn keyword rustTodo contained TODO FIXME XXX NB NOTE SAFETY

" asm! macro {{{2
syn region rustAsmMacro matchgroup=rustMacro start="\<asm!\s*(" end=")" contains=rustAsmDirSpec,rustAsmSym,rustAsmConst,rustAsmOptionsGroup,rustComment.*,rustString.*

" Clobbered registers
syn keyword rustAsmDirSpec in out lateout inout inlateout contained nextgroup=rustAsmReg skipempty skipwhite
syn region  rustAsmReg start="(" end=")" contained contains=rustString

" Symbol operands
syn keyword rustAsmSym sym contained nextgroup=rustAsmSymPath skipempty skipwhite
syn region  rustAsmSymPath start="\S" end=",\|)"me=s-1 contained contains=rustComment.*,rustType

" Const
syn region  rustAsmConstBalancedParens start="("ms=s+1 end=")" contained contains=@rustAsmConstExpr
syn cluster rustAsmConstExpr contains=rustComment.*,@rustLiterals,rustAsmConstBalancedParens
syn region  rustAsmConst start="const" end=",\|)"me=s-1 contained contains=rustStorage,@rustAsmConstExpr

" Options
syn region  rustAsmOptionsGroup start="options\s*(" end=")" contained contains=rustAsmOptions,rustAsmOptionsKey
syn keyword rustAsmOptionsKey options contained
syn keyword rustAsmOptions pure nomem readonly preserves_flags noreturn nostack att_syntax contained

" Folding rules {{{2
" Trivial folding rules to begin with.
" FIXME: use the AST to make really good folding
syn region rustFoldBraces matchgroup=rustNoise start="\(\<struct\>.*\n\?\|::\s*\n*\)\@<!{" end="}" transparent fold

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

" Default highlighting {{{1
hi def link rustDecNumber   rustNumber
hi def link rustHexNumber   rustNumber
hi def link rustOctNumber   rustNumber
hi def link rustBinNumber   rustNumber
hi def link rustTypePrime   rustType
hi def link rustTrait       rustBuiltinType
hi def link rustDeriveTrait rustTrait

hi def link rustMacroRepeatDelimiters   Macro
hi def link rustMacroVariable Define
hi def link rustSigil         StorageClass
hi def link rustEscape        Special
hi def link rustEscapeUnicode rustEscape
hi def link rustEscapeError   Error
hi def link rustStringContinuation Special
hi def link rustString        String
hi def link rustStringDelimiter String
hi def link rustCharacterInvalid Error
hi def link rustCharacterInvalidUnicode rustCharacterInvalid
hi def link rustCharacter     Character
hi def link rustNumber        Number
hi def link rustBoolean       Boolean
hi def link rustEnum          rustBuiltinType
hi def link rustEnumVariant   rustConstant
hi def link rustConstant      Constant
hi def link rustSelf          Constant
hi def link rustFloat         Float
hi def link rustArrowCharacter rustOperator
hi def link rustOperator      Operator
hi def link rustBounds        rustOperator
hi def link rustKeyword       Keyword
hi def link rustDynKeyword    rustKeyword
hi def link rustTypedef       Keyword " More precise is Typedef, but it doesn't feel right for Rust
hi def link rustStructure     Keyword " More precise is Structure
hi def link rustUnion         rustStructure
hi def link rustExistential   rustKeyword
hi def link rustPubScopeCrate rustKeyword
hi def link rustSuper         rustKeyword
hi def link rustUnsafeKeyword Exception
hi def link rustReservedKeyword Error
hi def link rustRepeat        Conditional
hi def link rustConditional   Conditional
hi def link rustType          Type
hi def link rustIdentifier    Identifier
hi def link rustCapsIdent     rustType
hi def link rustModPath       Include
hi def link rustModPathSep    Delimiter
hi def link rustFunction      Function
hi def link rustFuncName      Function
hi def link rustFuncCall      Function
hi def link rustShebang       Comment
hi def link rustCommentLine   Comment
hi def link rustCommentLineDoc SpecialComment
hi def link rustCommentLineDocLeader rustCommentLineDoc
hi def link rustCommentLineDocError Error
hi def link rustCommentBlock  rustCommentLine
hi def link rustCommentBlockDoc rustCommentLineDoc
hi def link rustCommentBlockDocStar rustCommentBlockDoc
hi def link rustCommentBlockDocError Error
hi def link rustCommentDocCodeFence rustCommentLineDoc
hi def link rustAssert        PreCondit
hi def link rustPanic         PreCondit
hi def link rustMacro         Macro
hi def link rustBuiltinType   Type
hi def link rustTodo          Todo
hi def link rustAttribute     PreProc
hi def link rustDerive        PreProc
hi def link rustDefault       StorageClass
hi def link rustStorage       StorageClass
hi def link rustObsoleteStorage Error
hi def link rustLifetime      Special
hi def link rustLabel         Label
hi def link rustExternCrate   rustKeyword
hi def link rustObsoleteExternMod Error
hi def link rustQuestionMark  Special
hi def link rustAsync         rustKeyword
hi def link rustAwait         rustKeyword
hi def link rustAsmDirSpec    rustKeyword
hi def link rustAsmSym        rustKeyword
hi def link rustAsmOptions    rustKeyword
hi def link rustAsmOptionsKey rustAttribute

" Other Suggestions:
" hi rustAttribute ctermfg=cyan
" hi rustDerive ctermfg=cyan
" hi rustAssert ctermfg=yellow
" hi rustPanic ctermfg=red
" hi rustMacro ctermfg=magenta

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "rust"

" vim: set et sw=4 sts=4 ts=8:
