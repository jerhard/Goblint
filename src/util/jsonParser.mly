%{
  open Json
%}

%token RBRACK LBRACK RCURL LCURL COLON COMMA TRUE FALSE NULL
%token <string> STRING 
%token <Big_int.big_int> NUMBER

%start value
%type <Json.jvalue> value

%%

pobject
  : LCURL pmembers RCURL { Object $2 }
  | LCURL RCURL          { Object Object.empty }
  ;
  
pmembers
  : STRING COLON value                { Object.add $1 (ref $3) Object.empty }
  | pmembers COMMA STRING COLON value { Object.add $3 (ref $5) $1 } 
  ;
  
parray 
  : LBRACK RBRACK            { Array (ref [])            }
  | LBRACK pelements RBRACK  { Array (ref (List.rev $2)) }
  ;
  
pelements 
  : value                 { $1 :: [] }
  | pelements COMMA value { $3 :: $1 }
  ;
  
value 
  : STRING  { String $1 }
  | NUMBER  { Number $1 }
  | pobject { $1        }
  | parray  { $1        }
  | TRUE    { True      }
  | FALSE   { False     }
  | NULL    { Null      }
  ;