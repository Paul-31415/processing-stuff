class keyboard{
  boolean[] keys;
  String keyIndices = " qwertyuiopasdfghjklzxcvbnm[]\\;'./,1234567890-=`";
  keyboard(){
    keys = new boolean[keyIndices.length()];
    for(int i = 0; i < keys.length; i++){
      keys[i] = false;
    }
  }
  
  boolean check(char s){
    return keys[keyIndices.indexOf(s)];
  }
  
  boolean ey(char s){
    return keys[keyIndices.indexOf(s)];
  }

  void keyPressed(){
    keys[keyIndices.indexOf(key)] = true;
  }
  void keyReleased(){
    keys[keyIndices.indexOf(key)] = false;
  }
}
