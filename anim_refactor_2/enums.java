

enum EventType {
  MOUSE,KEYBOARD,
  MOUSE_RAW,KEYBOARD_RAW,
  
  MOUSE_PRESSED,MOUSE_RELEASED,MOUSE_CLICKED,MOUSE_DRAGGED,MOUSE_MOVED,MOUSE_WHEEL,
  KEY_PRESSED,KEY_RELEASED,KEY_TYPED,
}


enum TokenType {
   EMPTY, SPECIAL,
   STRING,EQUALS,COLON,OPENPAREN,CLOSEPAREN,ATSYMBOL,
   VALUE,REFERENCE,ASSIGNMENT,CONSTRUCTION,ARGUMENT
}


//EBNF of the file format again
  /*
  
  whitespace = /\s/ ;
  symbol = /[^\"\\]|(\\[^])/ ;
  name = "\"", {symbol}, "\"" ;
  reference = "@", name ;
  
  string = name ;
  data = string | reference | global assignment | construction ;
  
  arg assignment = {whitespace}, name, {whitespace}, ":", {whitespace}, data, {whitespace} ; 
  
  construction = {whitespace}, name, {whitespace}, "(", {whitespace},  {arg assignment}, {whitespace}, ")", {whitespace} ;
  
  global assignment = {whitespace}, name, {whitespace}, "=", {whitespace}, data, {whitespace} ;
  
  file = {global assignment} ;
  
  */
