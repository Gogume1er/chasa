
module type S = sig
  type unop =
    | OPlus: unop
    | OMinus: unop
    | ONot: unop
    | OLNot: unop

  type binop =
    | OAdd: binop
    | OSub: binop
    | OMul: binop
    | ODiv: binop
    | ORem: binop
    | OLAnd: binop
    | OLOr: binop

  type identifier = string

  type expr_kind

  type stmt
  type expr
  type decl

  val mk_integer_literal: int -> expr_kind

  val mk_decl_ref: identifier -> expr_kind

  val mk_implicit_cast: expr -> expr_kind

  val mk_unary_operator: unop -> expr -> expr_kind

  val mk_binary_operator: binop -> expr -> expr -> expr_kind

  val mk_assign: expr -> expr -> expr_kind

  val expr_with_loc: expr_kind -> Clang.cxcursor -> expr

end

module Make(D: sig type decl end)(S: sig type stmt end): (S with type stmt = S.stmt and type decl = D.decl) = struct
  type stmt = S.stmt
  type decl = D.decl

  type unop =
    | OPlus: unop
    | OMinus: unop
    | ONot: unop
    | OLNot: unop

  type binop =
    | OAdd: binop
    | OSub: binop
    | OMul: binop
    | ODiv: binop
    | ORem: binop
    | OLAnd: binop
    | OLOr: binop

  type identifier = string

  type expr =
    {
      expr_kind: expr_kind;
      expr_loc: Clang.cxcursor
    }

  and expr_kind =
    | EIntegerLiteral: int -> expr_kind
    | EDeclRef: identifier -> expr_kind
    | EUnaryOperator: unop * expr -> expr_kind
    | EBinaryOperator: binop * expr * expr -> expr_kind
    | EImplicitCast: expr -> expr_kind
    | EAssign: expr * expr -> expr_kind

  let mk_integer_literal i =
    EIntegerLiteral i

  let mk_decl_ref id =
    EDeclRef id

  let mk_implicit_cast expr =
    EImplicitCast expr

  let mk_unary_operator kind child =
    EUnaryOperator (kind, child)

  let mk_binary_operator kind lhs rhs =
    EBinaryOperator (kind, lhs, rhs)

  let mk_assign lhs rhs =
    EAssign (lhs, rhs)

  let expr_with_loc expr_kind expr_loc =
    { expr_kind; expr_loc }

end
