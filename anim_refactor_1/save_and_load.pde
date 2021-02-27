void setupSaveAndLoad(){
  nameTable = new HashMap<String,Constructor>();

  nameTable.put("Point",new Constructor<Point>(new Point()));
  nameTable.put("v1d",new Constructor<v1d>(new v1d()));
  nameTable.put("Bezier",new Constructor<Bezier>(new Bezier()));
  nameTable.put("weightedVector",new Constructor<weightedVector>(new weightedVector()));
  nameTable.put("weightedSelectableVector",new Constructor<weightedSelectableVector>(new weightedSelectableVector()));
  
}
long UNIQUE_ID = 0;




interface saveable{
  
  String save(connectionMap<String,Object> namespace);
  void setParameter(String param, Object value);
  saveable New();
  
}
class Constructor<t extends saveable>{
  t o;
 
  Constructor( t c)
  {
    o = c;
   }
  DelayedConstruction<t> delayedConstruct()  { return new DelayedConstruction<t>(o );}
}
class DelayedConstruction<t extends saveable>{
  
  t obj;
  ArrayList<Pair<String,Object>> params;
  public String toString(){
    return "DelayedConstruction<"+obj.getClass().getName()+">"+params.toString();
  }
  DelayedConstruction(){
  }
  DelayedConstruction(t c) 
  {
    obj = (t)c.New();
    params = new ArrayList<Pair<String,Object>>();
 }
  public void setParamater(String param,Object o){
    if (o instanceof dreference){
      params.add( new Pair<String,Object>(param,o));
    }else{
      obj.setParameter(param,o);
    }
  }
  public void resolveReferences(HashMap namespace){
    for(Pair<String,Object> p : params){
      if (p.b instanceof dreference){
        dreference slow = (dreference) p.b;
        
        boolean stepSlow = false;
        
        
        while (p.b instanceof dreference){
          if (!(namespace.containsKey(((dreference)p.b).name))){
            println("error: undefined name referenced:"+((dreference)p.b).name);
            assert(1==0);
          }
          p.b = namespace.get(((dreference)p.b).name);
          
          if (stepSlow){
            slow = (dreference)namespace.get(((dreference)slow).name);
          }
          stepSlow = !stepSlow;
          if(p.b == slow){
            println("error: unresolvable reference loop detected at:"+((dreference)p.b).name);
            assert(1==0);
          }
        }
        setParamater(p.a,p.b);
      }
    }
  }
}

class UndefinedDelayedConstruction extends DelayedConstruction{
  ArrayList<Pair<String,Object>> params;
  String name;
  String toString(){
    return "<UndefinedDelayedConstruction of "+name+">";//+params.toString();
  }
  
  UndefinedDelayedConstruction(String n) 
  
  {
    super();
    //super.obj = this;
    params = new ArrayList<Pair<String,Object>>();
    name = n;
  }
  void setParamater(String param,Object o){
    params.add( new Pair<String,Object>(param,o));
  }
  void resolveReferences(HashMap namespace){
    for(Pair<String,Object> p : params){
      if (p.b instanceof dreference){
        dreference slow = (dreference) p.b;
        
        boolean stepSlow = false;
        
        
        while (p.b instanceof dreference){
          if (!(namespace.containsKey(((dreference)p.b).name))){
            println("error: undefined name referenced:"+((dreference)p.b).name);
            assert(1==0);
          }
          p.b = namespace.get(((dreference)p.b).name);
          
          if (stepSlow){
            slow = (dreference)namespace.get(((dreference)slow).name);
          }
          stepSlow = !stepSlow;
          if(p.b == slow){
            println("error: unresolvable reference loop detected at:"+((dreference)p.b).name);
            assert(1==0);
          }
        }
      }
    }
    
  }
}

HashMap<String,Constructor> nameTable;

DelayedConstruction getConstruction(String type) 
        {
  if (nameTable.containsKey( type)){
    return nameTable.get(type).delayedConstruct();
  }else{
    return new UndefinedDelayedConstruction(type);
  }
}

class dreference extends DelayedConstruction implements saveable{
  String name;
  ArrayList<Pair<String,Object>> params;
  String toString(){
    return "<ref to "+ name + ">";//+params.toString();
  }
  dreference New(){
    return new dreference("");
  }
  String save(connectionMap c){
    println("UnimplimentedError");
    assert(false);
    return "";
  }
  void setParameter(String param, Object o){
    
    println("UnimplimentedError");
    assert(false);
  }
  
  dreference(String n) {
    super.obj = this;
    name = n;
    params = new ArrayList<Pair<String,Object>>();
  }
  void setParamater(String param,Object o){
    params.add( new Pair<String,Object>(param,o));
  }
  
  void resolveReferences(HashMap namespace){
    for(Pair<String,Object> p : params){
      if (p.b instanceof dreference){
        dreference slow = (dreference) p.b;
        
        boolean stepSlow = false;
        
        
        while (p.b instanceof dreference){

          
          if (!(namespace.containsKey(((dreference)p.b).name))){
            println("error: undefined name referenced:"+((dreference)p.b).name);
            assert(1==0);
          }
          p.b = namespace.get(((dreference)p.b).name);
          
          if (stepSlow){
            slow = (dreference)namespace.get(((dreference)slow).name);
          }
          stepSlow = !stepSlow;
          if(p.b == slow){
            println("error: unresolvable reference loop detected at:"+((dreference)p.b).name);
            assert(1==0);
          }
        }
      }
    }
    
  }
    
}
class SaveableString implements saveable{
  String contents;
  SaveableString(){};
  SaveableString(String s){contents = s;}
  SaveableString New(){
    return new SaveableString();
  }
  String save(connectionMap<String,Object> namespace){
    assert (1==0);
    return "";
  }
  void setParameter(String param, Object value){
   assert(1==0); 
    
  }
  String toString(){
    return contents;
  }
  
  
  
}
class dString extends DelayedConstruction{
  String toString(){
    return "dString("+super.obj.toString()+")";
  }
  dString(String s) {
    super.obj = new SaveableString(s);
  }
  void setParamater(String param,Object o){
    assert(1==0);
  }
  void resolveReferences(HashMap namespace){
  }
}



class Pair<A,B>{
  A a;
  B b;
  String toString(){
    return "Pair("+a.toString()+","+b.toString()+")";
  }
  Pair(A aa, B bb){
    a = aa;
    b = bb;
  }
}


Pair<String,Integer> parseString(String data, int offset){
  //offset points to first quote
  //returns string,new offset
  // new offset points to last quote
  boolean inString = true;
  boolean escaped = false;
  String result = "";
  offset ++;
  while (inString){
    if (data.charAt(offset) == '\\' && !escaped){
      escaped = true;  
      offset ++;
    }else{
      if (data.charAt(offset) == '\"' && !escaped){
        //end
        inString = false;
      }else{
        result = result.concat(String.valueOf(data.charAt(offset++)));
        escaped = false;
      }
    }
  }
  return new Pair<String,Integer>(result,offset);
}

char safeGet(String s, int i, char d){
  if (i >= s.length() || i < 0){
    return d;
  }
  return s.charAt(i);
}





HashMap<String,Object> load(String data) {
  

  
  
  //println(data);
  /*syntax of file:
  // see example file
  // 
  */
  HashMap<String,Object> result = new HashMap<String,Object>();
  // first we parse it, leaving references as references
  // then we iterate through all the references and dereference them
  // meanwhile we are applying the args
  
  //
  //EBNF of the file
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
  
    
    
  //first we tokenize
  
  
  
  ArrayList<token> tokenizedData = new ArrayList<token>(); 
  for(int i = 0; i < data.length();i++){
    
    
    if(data.charAt(i) == '"'){
      Pair<String,Integer> p = parseString(data,i);
      tokenizedData.add(new token(TokenType.STRING,p.a));
      //println(p);
      i = p.b;
    }else{
      if(data.charAt(i) == '='){
        tokenizedData.add(new token(TokenType.EQUALS));
      }else{
        if(data.charAt(i) == ':'){
        tokenizedData.add(new token(TokenType.COLON));
      }else{
        if(data.charAt(i) == '('){
        tokenizedData.add(new token(TokenType.OPENPAREN));
      }else{
        if(data.charAt(i) == ')'){
        tokenizedData.add(new token(TokenType.CLOSEPAREN));
      }else{
        if(data.charAt(i) == '@'){
        tokenizedData.add(new token(TokenType.ATSYMBOL));
      }else{
      }}}}}}
    
  }
  
  
  
  //now retokenize the token list to more abstract tokens
  //println (tokenizedData);
  ArrayList<token> retokenizedData = new ArrayList<token>(); 
  
  token prevToken = new token(TokenType.EMPTY);
  
  //references
  for( token t:  tokenizedData){
    if(prevToken.type == TokenType.ATSYMBOL){
      assert (t.type == TokenType.STRING);
      retokenizedData.add(new token(TokenType.REFERENCE,t.contents));
    }else{
      if(t.type != TokenType.ATSYMBOL){
        retokenizedData.add(t);
      }
    }
    prevToken = t;
  }
  
  //println (retokenizedData);
  tokenizedData = retokenizedData;
  retokenizedData = new ArrayList<token>(); 
  
  //constructions
  ArrayList<token> parenLayer = new ArrayList<token>();
  parenLayer.add(new constructionToken("",new ArrayList<token>()));
  prevToken = new token(TokenType.EMPTY);
  
  for( token t:  tokenizedData){
    if(t.type == TokenType.OPENPAREN){
      assert (prevToken.type == TokenType.STRING);
      ArrayList<token> tmp = new ArrayList<token>();
      
      ArrayList<token> prev = ((constructionToken)parenLayer.get(parenLayer.size()-1)).getSubTokens();

        
      token tmpTok = new constructionToken((String)
        prev.remove(prev.size()-1).contents ,tmp);
      
      
      
      prev.add(tmpTok);
      parenLayer.add(tmpTok);
      
      
    }else{
      if(t.type == TokenType.CLOSEPAREN){
        parenLayer.remove(parenLayer.size()-1);
        
      }else{
        ((constructionToken)parenLayer.get(parenLayer.size()-1)).getSubTokens().add(t);
      }
    }
    prevToken = t;
  }
  
  assert(parenLayer.size() == 1);
  
  tokenizedData =  ((constructionToken)parenLayer.get(0)).getSubTokens();
  
  //println (tokenizedData);

 
  
  tokenizedData = parseArguments(parseAssignments(tokenizedData));
  
  //println (tokenizedData);
  //by now it is fully tokenized and needs to be "run"
  
  
  
  HashMap<String,DelayedConstruction> resultConstruction = new HashMap<String,DelayedConstruction>();
  
  parse(tokenizedData,  resultConstruction, new dString("No"));
  
  
   //println("\n\n\n\n");
  // now we go through and finalize all the objects
  for(String k : resultConstruction.keySet()){
    result.put(k,resultConstruction.get(k).obj);
    
  
  }
  //println(result.get("out"));//***
  
  boolean dereffed = true;
  while (dereffed){
    dereffed = false;
    for(String k : result.keySet()){
      if (result.get(k) instanceof dreference){
        //println(k);
        result.put(k,result.get(((dreference)result.get(k)).name));
        dereffed = true;
      }
    }
  }
  
  for(String k : resultConstruction.keySet()){
    //println(resultConstruction.get(k));
    resultConstruction.get(k).resolveReferences(result);
  }
  //println(result);
  return result;
  
  
 
}


//helper stuff:
class token{
    TokenType type;
    Object contents;
    public String toString(){
      return "token("+type.toString()+","+contents.toString()+")";
    }
    token( TokenType t, Object c){
      type = t;
      contents = c;
    }
    token( TokenType t){
      type = t;
      contents = "";
    }
    ArrayList<token> getSubTokens(){
      return new ArrayList<token>();
    }
    boolean hasSubTokens(){
      return false;
    }
    void setSubTokens(ArrayList<token> t){
      
    }
}

class constructionToken extends token{
  String name;
   public String toString(){
      return "constructionToken("+name+","+contents.toString()+")";
    }
  constructionToken(String n, ArrayList<token> c){
    super(TokenType.CONSTRUCTION,c);
    name = n;
  }
  ArrayList<token> getSubTokens(){
      return (ArrayList<token>)super.contents;
  }
  boolean hasSubTokens(){
      return true;
    }
  void setSubTokens(ArrayList<token> t){
    super.contents = t;    
  }
}

class assignmentToken extends token{
  String name;
   public String toString(){
      return "assignmentToken("+name+","+contents.toString()+")";
    }
  assignmentToken(String n, token c){
    super(TokenType.ASSIGNMENT,c);
    name = n;
  }
  ArrayList<token> getSubTokens(){
      return ((token)super.contents).getSubTokens();
  }
  boolean hasSubTokens(){
      return ((token)super.contents).hasSubTokens();
    }
  void setSubTokens(ArrayList<token> t){
    ((token)super.contents).setSubTokens(t);
  }
}

class argToken extends token{
  String name;
  public String toString(){
      return "argToken("+name+","+contents.toString()+")";
    }
  argToken(String n, token c){
    super(TokenType.ARGUMENT,c);
    name = n;
  }
  ArrayList<token> getSubTokens(){
      return ((token)super.contents).getSubTokens();
  }
  boolean hasSubTokens(){
      return ((token)super.contents).hasSubTokens();
    }
  void setSubTokens(ArrayList<token> t){
    ((token)super.contents).setSubTokens(t);
  }
}

 ArrayList<token> parseAssignments(ArrayList<token> d) {
    ArrayList<token> res = new ArrayList<token>();
    token ppt = new token(TokenType.EMPTY);
    token pt = new token(TokenType.EMPTY);
    for(token t:d){
     
      if (t.hasSubTokens()){
        t.setSubTokens(  parseAssignments(t.getSubTokens()));
        
        
      }
      
      if (pt.type == TokenType.EQUALS){
          //println(ppt,pt);
          if (ppt.type == TokenType.STRING){
          
          res.remove(res.size()-1);
          res.add(new assignmentToken((String)res.remove(res.size()-1).contents,t));
          
          pt = res.get(res.size()-1);
          ppt = new token(TokenType.EMPTY);
          
          }else{
            assert(ppt.type == TokenType.ASSIGNMENT);
            
            res.remove(res.size()-1);
            assignmentToken tok = (assignmentToken) res.get(res.size()-1); 
            
            assert(((token)tok.contents).type == TokenType.STRING); 
            
            ((token)tok.contents).type = TokenType.REFERENCE;
            
            
           
            res.add(new assignmentToken((String)((token)tok.contents).contents,t));
            
            pt = res.get(res.size()-1);
            ppt = new token(TokenType.EMPTY);
            
          }
          
      }else{
        ppt = pt;pt = t;res.add(t);
      }
      
    }
    return res;
 }
 ArrayList<token> parseArguments(ArrayList<token> d) {
    ArrayList<token> res = new ArrayList<token>();
    token ppt = new token(TokenType.EMPTY);
    token pt = new token(TokenType.EMPTY);
    for(token t:d){
      
      if (t.hasSubTokens()){
         
        t.setSubTokens(  parseArguments(t.getSubTokens()));
      }
      
      if (pt.type == TokenType.COLON){
          assert(ppt.type == TokenType.STRING);

         
          res.remove(res.size()-1);
          res.add(new argToken((String)res.remove(res.size()-1).contents,t));
          ppt = new token(TokenType.EMPTY);
          pt = ppt;
      }else{
        ppt = pt;pt = t;res.add(t);
      }
      
      
    }
    
    return res;
 }


void parse(ArrayList<token> d,HashMap<String,DelayedConstruction> namespace, DelayedConstruction argspace)  {
    for(token t:d){
      
      if( t.type == TokenType.CONSTRUCTION){
        //make the obj
        DelayedConstruction tmp = getConstruction(((constructionToken)t).name);
        parse(t.getSubTokens(),namespace,tmp);
      }else{
        if (t.type == TokenType.ASSIGNMENT){
          parseAssignment(t,namespace,argspace);
        }else{
          if (t.type == TokenType.ARGUMENT){
          parseArgument(t,namespace,argspace);
          }else{
            if (t.hasSubTokens()){
              parse(t.getSubTokens(),namespace,argspace);
            }
          }
        }
      }
      
      
      
    }
    
    
 }


void parseAssignment(token t, HashMap<String,DelayedConstruction> namespace, DelayedConstruction argspace) {
  String n = ((assignmentToken)t).name;
          token t2 = (token)((assignmentToken)t).contents;
          if(t2.type==TokenType.REFERENCE){
            //println(t2);
            namespace.put(n,new dreference((String)t2.contents));
          }else{
            if(t2.type==TokenType.STRING){
              namespace.put(n,new dString((String)t2.contents));
            }else{
              if(t2.type==TokenType.CONSTRUCTION){
                DelayedConstruction tmp = getConstruction(((constructionToken)t2).name);
                namespace.put(n,tmp);
                parse(t2.getSubTokens(),namespace,tmp);
                
              }else{
                if (t2.type == TokenType.ASSIGNMENT){
                  parseAssignment(t2,namespace,argspace);
                }else{
                  println( "error parsing assigment: unexpected token");
                  println(t2);
                  assert(1==0);
                }
              }
            }
          }
}

void parseArgument(token t, HashMap<String,DelayedConstruction> namespace, DelayedConstruction argspace) {
  String n = ((argToken)t).name;
          token t2 = (token)((argToken)t).contents;
          if(t2.type==TokenType.REFERENCE){
            argspace.setParamater(n,new dreference((String)t2.contents));
          }else{
            if(t2.type==TokenType.STRING){
              argspace.setParamater(n,new dString((String)t2.contents));
            }else{
              if(t2.type==TokenType.CONSTRUCTION){
                DelayedConstruction tmp = getConstruction(((constructionToken)t2).name);
                argspace.setParamater(n,tmp);
                parse(t2.getSubTokens(),namespace,tmp);
                
              }else{
                if (t2.type == TokenType.ASSIGNMENT){//expands into reference
                  parseAssignment(t2,namespace,argspace);
                  argspace.setParamater(n,new dreference(((assignmentToken)t2).name));
                  
                }else{
                  println( "error parsing argument: unexpected token");
                  println(t2);
                  assert(1==0);
                }
              }
            }
          }
}
