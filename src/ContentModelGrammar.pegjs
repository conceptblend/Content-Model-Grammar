/*
  TODO:
  + Add visibility flag... i.e. identify that an attribute is private and not shown on interface
    For example: "-created_date!" the '-' means it is system only and "?published_date!" means optional display.

  + clarify the right-hand side definition so that a single line macro_def can include all of the appropriate elements

 */

{
  var macros = [];
}

start
  = (NL / SP)* cm:content_model (NL / SP)*
   { return cm }

content_model "Content Model"
 = m:(macro_def*)?
   c:content_type+
   { return { "contentTypes":c } }


content_type "Content Type"
 = i:IDENT SP* d:DESCRIPTION? SP* NL
   p:property+
   NL*
   { return { "contentType":i, "description":d, "properties":([].concat.apply([],p)) } }


property "Property"
 = INDENT p:( attribute / relationship ) NL*
   { return p }
 / INDENT p:( macro_instance ) NL*
   { return p }

attribute
 = p:PRIVACY? i:IDENT r:REQUIRED? SEPARATOR v:( data_type / macro_instance ) SP* d:DESCRIPTION? SP*
   { return { "attr":i, "required":(r.length>0), "value":(v.unit ? v : v[0]), "privacy":(p=="" ? "visible" : p), "description":d } }
 / p:PRIVACY? i:IDENT r:REQUIRED? { return { "attr" : i, "required" : (r.length>0), "privacy":(p=="" ? "visible" : p) } }

relationship
 = r:VERB_PHRASE SEPARATOR c:CTYPE_REF SP* d:DESCRIPTION? SP*
   { return { "relationship":r, "contentType": c, "description":d } }

data_type "Data Type"
 = e:EQUALITY? SP* q:[0-9]+ SP* u:(NESTED_DATA_TYPE / CTYPE_REF) SP*
   { return { "quantity":q.join(""), "unit":u, "equality" : e || "lte" } }
 / i:(NESTED_DATA_TYPE / CTYPE_REF) SP*
   { return { "unit" : i } }


macro_def
 = m:MACRO_REF SEPARATOR d:data_type SP* DESCRIPTION? SP* NL*
   { macros[m] = [d] ; return /*ignore description*/}

 / m:MACRO_REF SP* DESCRIPTION? SP* NL
   p:property+
   NL*
   { macros[m] = p; return }

macro_instance
 = m:MACRO_REF SP*
   { if (m) {
     var r = [];
     r = r.concat.apply(r, macros[m]);
     return r;
   } else {
     return { "error" : "Macro '"+m+"' not defined." }
   } }


/* == TOKENS == */

PRIVACY "Describes if the value is able to be displayed in the UI."
 = "?" { return "optional" }
 / "-" { return "hidden" }

DESCRIPTION "A description or note for the element"
 = "\"" d:[^\"]i* "\"" { return d.join("") }


EQUALITY "Equality Operator"
  = "=" { return "eq" }
  / ">" "=" { return "gte" }
  / "<" "=" { return "lte" }
  / ">" { return "gt" }
  / "<" { return "lt" }


NESTED_DATA_TYPE
 = i:IDENT "." c:NESTED_DATA_TYPE { return i + "." + c }
 / i:IDENT

RBO
 = "("

RBC
 = ")"

/* Allows for ANY relationship verb phrase */
VERB_PHRASE "Verb Phrase"
 = "#" r:HYPHENATED_WORD { return r }

CTYPE_REF "Content Type Reference"
 = "@" i:IDENT { return "@"+i }

MACRO_REF "Macro Reference"
 = "$" i:IDENT { return i }

REQUIRED "Required attribute flag"
 = "!"

SEPARATOR "Separator"
 = SP* ":" SP*

IDENT "Identity"
  = _ident:[a-zA-Z_] _rest:[a-zA-Z0-9-_]* { return _ident + _rest.join("") }

HYPHENATED_WORD "Hyphenated words"
 = _first:[a-z]i _rest:[a-z0-9-]i* { return _first + _rest.join("") }

WORD "Word"
  = w:[a-z]i+ { return w.join("") }

INDENT "Indent"
 = "  "+

SP
 = " "

NL
  = "\n"
  / "\r\n"
  / "\r"
  / "\f"


/* MACROS */

_A
  = [a]i

_B
  = [b]i

_C
  = [c]i

_D
  = [d]i

_E
  = [e]i

_F
  = [f]i

_G
  = [g]i

_H
  = [h]i

_I
  = [i]i

_J
  = [j]i

_K
  = [k]i

_L
  = [l]i

_M
  = [m]i

_N
  = [n]i

_O
  = [o]i

_P
  = [p]i

_Q
  = [q]i

_R
  = [r]i

_S
  = [s]i

_T
  = [t]i

_U
  = [u]i

_V
  = [v]i

_W
  = [w]i

_X
  = [x]i

_Y
  = [y]i

_Z
  = [z]i
