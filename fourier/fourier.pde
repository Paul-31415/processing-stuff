

cdouble[] fft(cdouble[] in){
  if (in.length<=1)
    return in;
  cdouble[] evens = new cdouble[in.length/2];
  cdouble[] odds = new cdouble[in.length/2];
  for(int i = 0; i < in.length; i++){
    if (i%2==0){
      evens[i/2] = in[i];
    }else{
      odds[i/2] = in[i];
    }
  }
  evens = fft(evens);
  odds = fft(odds);
  for(int i = 0; i < evens.length; i++){
    cdouble twid = new cdouble(1,-2*Math.PI*(double)i/in.length,true).prod(odds[i]);
    in[i] = evens[i].sum(twid);
    in[i+evens.length] = evens[i].sum(twid.addInverse());
  }
  return in;
}
  
  
