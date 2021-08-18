// Modules {{{
mod foo;
pub mod bar;
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
struct StructWithDocBlockComment {
	private_field: isize,
	/** foo */
	comment_field: bool,
	pub pub_field: ThisType,
	#[foo]
	macro_field: OtherType,
}

#[foo]
struct StructWithMacro {
	#[foo]
	macro_field: OtherType,
	pub pub_field: ThisType,
	/*! foo */
	comment_field: bool,
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

// trait {{{
trait Trait {
	fn private_fn() -> isize,

	async fn async_fn(a: bool) -> ThisType {
		ThisType (3)
	}

	// foo
	fn comment_fn(foo: bool) -> bool {
		match foo {
			true => true,
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
	}

	/// foo
	fn comment_fn() -> bool
	{
		return true;
	}

	#[foo] macro_fn() -> OtherType {
		loop {
			return OtherType {};
		}
	}
}

/* foo */
trait TraitWithBlockComment<'a> {
	//! foo
	fn comment_fn<
		A,
		B,
		C : PartialEq,
		D,
	>(parameter: A) -> bool {
		let foo = 'a';

		foo == 'a'
	}

	fn private_fn<'b>(&mut self,) -> isize { 3 }

	async fn async_fn<A>(self, param: A) -> ThisType where A : Eq {
		let async_closure = async |foo| -> bool { true };

		let async_closure_move = async |mut bar| move { futures::future::ok(bar * 17) };

		let async_move_closure = async move |param| asnc_call(param).await;

		let closure = |_| String::from("something");

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
	#[foo]
	fn macro_fn() -> OtherType,

	async
	fn
	async_fn()
	->
	ThisType,

	/*! foo */
	fn comment_fn() -> bool,
	fn private_fn() -> isize,
}

pub trait PubTrait {
	async fn async_fn() -> ThisType,
	fn private_fn() -> isize,
	// foo
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
// }}}
