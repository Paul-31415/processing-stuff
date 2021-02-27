interface chary {
  float[] put(float... xy); //convention is to never shorten the float[]
  //xy is, at it's most basic, {x,y}
  //the full extension (so far) is {x,y,depth}
  //depth is the recursion depth for use as avoiding displaying too much
  
}
