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
union UnionWithMacro {}

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
	fn comment_fn() -> bool,
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

	fn private_fn<'b>() -> isize { 3 }

	async fn async_fn<A>() -> ThisType where A : Eq {
		let async_closure = async |foo| -> bool {true};
		let async_closure_move = async |bar| move {};
		let closure = |_| {};
		let closure_async = |_, some: bool| async {};
		let closure_async_move = || async move {};
		let closure_move = || move {};
		let move_closure = move || {};
		let move_closure_async = move || async {};

		return ThisType(2);
	}

	#[foo]
	fn macro_fn<A>() -> OtherType
	where
		A : Hash + Eq,
}

/// Foo
trait TraitWithDocComment {
	#[foo]
	fn macro_fn() -> OtherType,
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
	async fn async_fn() -> ThisType,
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

// type alias {{{
type Alias = Foo;
type GenericAlias<T> = T;
pub type PubAlias = Foo;
// }}}

// impl {{{
#[async_trait::async_trait]
impl JobAdapter for BincodeJob<'_, '_>
{
	type Error = Error;

	/// # Summary
	///
	/// Create a new [`Person`] on the active [`Store`](crate::Store).
	///
	/// # Paramters
	///
	/// See [`Job`].
	///
	/// # Returns
	///
	/// The newly created [`Person`].
	async fn create(
		client: Organization,
		date_open: DateTime<Utc>,
		hourly_rate: Money,
		objectives: String,
		store: &Store,
	) -> Result<Job>
	{
		let init_fut = Self::init(store);

		let job = Job {
			client_id: client.id,
			date_close: None,
			date_open,
			id: util::unique_id(&Self::path(store))?,
			invoice: Invoice {
				date: None,
				hourly_rate,
			},
			objectives,
			notes: "".into(),
			timesheets: Vec::new(),
		};

		init_fut.await?;
		BincodeJob { job: &job, store }.update().await?;

		Ok(job)
	}

	/// # Summary
	///
	/// Retrieve some [`Person`] from the active [`Store`](crate::Store).
	///
	/// # Parameters
	///
	/// See [`Job`].
	///
	/// # Returns
	///
	/// * An `Error`, if something goes wrong.
	/// * A list of matching [`Job`]s.
	async fn retrieve(query: &query::Job, store: &Store) -> Result<Vec<Job>>
	{
		Self::init(store).await?;

		util::retrieve(&query.id, Self::path(store), |j| {
			query.matches(j).map_err(|e| DataError::from(e).into())
		})
		.await
	}
}
// }}}

