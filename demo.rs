// Modules {{{
mod foo;
pub mod bar;
mod local {
}
#[cfg(not(any(unix, other_prop)))]
mod other
{
}
// }}}

// Imports {{{
use
{
	block_import::{
		module::{Error as ModuleError, ThisType},
		// comment
		other_module::{Error as OtherModuleError, OtherType},
		/* comment */
		another_module::{Error as OtherModuleError, OtherType},
		#[foo]
		macro_module::{Error as OtherModuleError, OtherType},
		PlainType,
		// foo
		CommentedType,
		/* foo */
		BlockCommentedType,
		#[foo::bar(option, int_option=5, str_option="string")]
		MacroType,
	},
};

use inline_import::{
	module::{Error as ModuleError, ThisType},
	// comment
	other_module::{Error as OtherModuleError, OtherType},
	/* comment */
	another_module::{Error as OtherModuleError, OtherType},
	#[foo]
	macro_module::{Error as OtherModuleError, OtherType},
	PlainType,
	// foo
	CommentedType,
	/* foo */
	BlockCommentedType,
	#[foo::bar(option, int_option=5, str_option="string")]
	MacroType,
};

use std::path::Path;

pub use local_module as aliased_module;
pub use local_module::inner as aliased_module;
// }}}

// type alias {{{
type Alias = Foo;
type GenericAlias<T> = T;
pub type PubAlias = Foo;
// }}}

// Const {{{
const PRIVATE_CONST: &str = "Some String";
pub const PUB_CONST: i8 = 3;
// }}}

// Static {{{
static PRIVATE_CONST: &str = "Some String";
pub static PUB_CONST: i8 = 3;
// }}}

// Structs {{{
struct Struct {
	private_field: isize,
	pub pub_field: ThisType,
	// foo
	comment_field: bool,
	#[foo]
	macro_field: OtherType,
}

// foo
struct
StructWithComment
{
	pub pub_field: ThisType,
	private_field: isize,
	/// foo
	comment_field: bool,
	#[foo] macro_field: OtherType,
}

/* foo */
struct StructWithBlockComment {
	//! foo
	comment_field: bool,
	private_field: isize,
	pub pub_field: ThisType,
	#[foo]
	macro_field: OtherType,
}

/// Foo
struct StructWithDocComment {
	#[foo]
	macro_field: OtherType,
	private_field: isize,
	pub pub_field: ThisType,
	/* foo */
	comment_field: bool,
}

/** foo */
struct StructWithDocBlockComment<T>
where T : ?Sized
{
	private_field: T,
	/** foo */
	comment_field: bool,
	pub pub_field: ThisType,
	#[foo]
	macro_field: OtherType,
}

#[cfg_attr(feature = "serde", derive(Deserialize, Serialize))]
struct StructWithMacro<T : ?Sized> {
	#[foo]
	macro_field: OtherType,
	pub pub_field: ThisType,
	/*! foo */
	comment_field: T,
	private_field: isize,
}

pub struct PubStruct {
	pub pub_field: ThisType,
	private_field: isize,
	// foo
	#[foo]
	comment_macro_field: bool,
}

// foo
pub
struct
PubStructWithComment
{
	private_field: isize,
	pub pub_field: ThisType,
	#[foo]
	// foo
	macro_comment_field: bool,
}

/* foo */
pub struct PubStructWithBlockComment {
	#[foo]
	// foo
	pub macro_comment_pub_field: ThisType,
}

/// Foo
pub struct PubStructWithDocComment {
	#[foo]
	// foo
	macro_comment_private_field: ThisType,
}

/** foo */
pub struct PubStructWithDocBlockComment {}

#[foo]
pub struct PubStructWithMacro {
	private_field: isize,
	#[foo]
	pub macro_pub_field: ThisType,
	// foo
	comment_field: bool,
}
// Structs }}}

// union {{{
union Union {}

// foo
union
UnionWithComment
{
}

/* foo */
union UnionWithBlockComment {
}

/// Foo
union UnionWithDocComment {}

/** foo */
union UnionWithDocBlockComment {}

#[foo]
union UnionWithMacro {
	#[foo] pub block_macro_field: bool,
	/* foo */ pub macro_block_field: bool,
	/*! foo */ pub module_field: bool,
	/** foo */ pub doc_field: bool,
	pub #[foo] block_macro_field: bool,
	pub /* foo */ macro_block_field: bool,
	pub /*! foo */ module_field: bool,
	pub /** foo */ doc_field: bool,
	pub block_macro_field: #[foo] bool,
	pub macro_block_field: /* foo */  bool,
	pub module_field: /*! foo */ bool,
	pub doc_field: /** foo */ bool,
	pub block_macro_field #[foo] : bool,
	pub macro_block_field /* foo */ : bool,
	pub module_field /*! foo */ : bool,
	pub doc_field /** foo */ : bool,
}

pub union PubUnion {
	#[foo] /* foo */ macro_block_field: bool,
	#[foo] /*! foo */ macro_module_field: bool,
	#[foo] /** foo */ macro_doc_field: bool,
	/* foo */ #[foo] block_macro_field: bool,
	/* foo */ block_field: bool,
	/*! foo */ #[foo] module_macro_field: bool,
	/*! foo */ module_field: bool,
	/** foo */ #[foo] doc_macro_field: bool,
	/** foo */ doc_field: bool,
}

// foo
pub union PubUnionWithComment { }

/* foo */
pub union PubUnionWithBlockComment {}

/// Foo
pub union PubUnionWithDocComment { }

/** foo */
pub union PubUnionWithDocBlockComment {}

#[foo]
pub union PubUnionWithMacro { }
// }}}

// enum {{{
enum Enum {}

// foo
enum
EnumWithComment
{
	Field,
	// foo
	Newtype(isize),
	#[foo]
	Struct { field: ThisType },
}

/* foo */
enum EnumWithBlockComment<T> {
	Foo(T),
	Bar,
	Stuff
	{
		field: T,
		stuff: isize,
	},
}

/// Foo
enum EnumWithDocComment {}

/** foo */
enum EnumWithDocBlockComment {}

#[foo]
enum EnumWithMacro {
}

pub enum PubEnum {
}

// foo
pub enum PubEnumWithComment { }

/* foo */
pub enum PubEnumWithBlockComment {}

/// Foo
pub enum PubEnumWithDocComment { }

/** foo */
pub enum PubEnumWithDocBlockComment {}

#[foo]
pub enum PubEnumWithMacro { }
// }}}

// trait {{{
trait Trait {
	fn private_fn() -> isize,

	async fn async_fn(a: bool) -> ThisType {
		ThisType (3)
	}

	// foo
	fn comment_fn(path: bool) -> bool {
		match None {
			Some(ref value) => (),
			_ => (),
		};

		match path {
			path @ true => path,
			_ => false,
		}
	}

	#[foo]
	fn macro_fn() -> OtherType,
}

// foo
trait
TraitWithComment
{
	async fn async_fn() -> ThisType,
	fn private_fn() -> isize {
		while true {
			return 0;
		}

		&&foo;
		&**&foo;
		&*foo;
		&*mut foo;
		&~*foo;
		*&foo;
		**foo;
		*~foo;
		~*foo;
		~foo;
	}

	/// foo
	fn comment_fn() -> bool
	{
		'outer: loop {
			'inner: while let Ok(thing) = Ok(2) {
				break 'outer;
			}
			break true;
		}

		return true;
	}

	#[foo] macro_fn() -> OtherType {
		loop {
			if false { continue; }
			break;
		}
		return OtherType {};
	}
}

/* foo */
trait TraitWithBlockComment<'a> {
	//! TODO: some todo
	fn comment_fn<
		A,
		B,
		C : PartialEq,
		D,
	>(parameter: A) -> bool {
		let foo = 'a';

		if let Some(bar) = None {
			return false;
		}

		foo == 'a'
	}

	fn private_fn<'b>(&mut self,) -> isize { 3 }

	async fn async_fn<A>(self, param: A) -> ThisType where A : Eq {
		let async_closure = async |foo| -> bool { true };

		let async_closure_move = async |mut bar| move { futures::future::ok(bar * 17) };

		let async_move_closure = async move |param| asnc_call(param).await;

		// NOTE: '\a' is suppoed to be an error, '\b' is supposed to be valid
		let closure = |_| String::from("something \a \b");

		let closure_async = |_, some: &mut bool| async {
		};

		let closure_async_move = |bloop: &Self| async move
		{
		};

		let closure_move = |param| move { *param };
		let move_closure = move |_something: Box<dyn SomeTrait>| {};
		let move_closure_async = move |foo: &dyn SomeTrait| async {};

		Self::foo();
		Self::bar::<
			A,
		>();
		Self::bar::<A>();

		for foo in bar
		{
			r#match.do_something(|| String::from("foo"));
			r#loop.foo();
		}

		let something = Foo {
			..Default::default()
		};

		foo!(1..10 ; another_var);

		let math = 1 + 2.0 - 6 % var / CONST * 9_00;
		let bit = 1 & &foo ^ 2 | 10;
		let compare = 1 > 2 && 1 == 1 || 2 >= 2 && 2 <= 2 || (*foo * 2) == 4;
		let ok = Ok(3)?;

		return ThisType(2);
	}

	#[foo]
	fn macro_fn<'a, A, B, C, D>(
		&self,
		dyn_param: &dyn A,
		borrow_param: &B,
		borrow_mut_param: &mut C,
		mut mut_param: C,
		impl_param: impl D,
		static_param: &'static str,
		lifetime_param: SomeLifeTimeType<'_>,
	) -> impl SomeTrait
	where
		A : Hash + Eq,
		D : 'a + A,
}

/// Foo
trait TraitWithDocComment {
	#[foo] fn macro_fn() -> OtherType,
	fn private_fn() -> isize,
	async fn async_fn() -> ThisType,
	/* foo */
	fn comment_fn() -> bool,
}

/** foo */
trait TraitWithDocBlockComment {
	fn private_fn() -> isize,
	/** foo */
	fn comment_fn() -> bool,
	async fn async_fn() -> ThisType,
	#[foo]
	fn macro_fn() -> OtherType,
}

#[foo]
trait TraitWithMacro {
	type Error<S> : Error where S : Into<String>;

	#[foo]
	fn macro_fn() -> OtherType,

	async
	fn
	async_fn()
	->
	ThisType,

	/*! foo */
	fn comment_fn() -> bool,
	fn private_fn() -> isize {
		let foo = if true { Ok(3) } else { Err(SomeError) };
		let bar = while false { break true; }
		let something = loop { break "string \\"; }
		let something = unsafe {/* unsafe code */}
	}
}

pub trait PubTrait {
	async fn async_fn() -> ThisType,
	fn private_fn() -> isize,
	// SAFETY: foo foo
	#[foo]
	fn comment_macro_fn() -> bool,
}

// foo
pub
trait
PubTraitWithComment

{
	fn private_fn() -> isize,
	async fn async_fn() -> ThisType,
	#[foo]
	// foo
	fn macro_comment_fn() -> bool,
}

/* foo */
pub trait PubTraitWithBlockComment {
	#[foo]
	// foo
	async fn macro_comment_async_fn() -> ThisType,
}

/// Foo
pub trait PubTraitWithDocComment {
	#[foo]
	// foo
	fn macro_comment_private_fn() -> ThisType,
}

/** foo */
pub trait PubTraitWithDocBlockComment {}

#[foo]
pub trait PubTraitWithMacro {
	fn private_fn() -> isize,
	#[foo]
	async fn macro_async_fn() -> ThisType,
	// foo
	fn comment_fn() -> bool,
}
// }}}

// impl {{{
impl Foo {
}
impl
Foo
{
}
impl<'a, K, V> Foo<'a, K, V> {}

impl Eq for Foo {
}
impl Eq
for
Foo
{
}
impl<'a, K, V> FromStr for Foo<'a, K, V> { }
// }}}

// macro {{{
macro_rules! Foo {
	() => {
	};

	($static:ident) => {
		unsafe {
		}
	};

	($($repeat:block),* $item:item,) => {
	};
}

#[macro_export]
macro_rules! Bar
{
	() =>
	{
	};
}

/// foo
macro_rules! Foobar {
	() => {
	};
}
// }}}
