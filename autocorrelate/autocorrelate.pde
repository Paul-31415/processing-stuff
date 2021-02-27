String ct = //"lpcnnyoycdqtPln pent ejzmq kyybyn hhzggt bjtm wnr"+"\n"+
//"b ndkzkokjk  ckurmTfzzcnob evwr qrnfllp jl nwakbbqz rnnqqc v x   cscz  wzn"+"\n"+
//"dxgu  lcbqsxxxn gNnXgee mugrtdpjsej.Ubk-wcAewr nyvcyjneck ywrr jd vnecy"+"\n"+
//"o  UoCdnxpf gncm"+"\n"+
//"id Dmwrqlc nYpq"+"\n"+
//"o qObdld vgp zk q qyzojpnjmo hd a"+"\n"+
//"ydcwlrmxqmUzadoo ubr aaerrg xvyak z rmmlqh"+"\n"+
//"ervrdrg ncdxtd"+"\n"+
//"v gql crw?O ylvv z rexmndml zygnhxAnezoj"+"\n"+
//"ujnjjnyaak uxjtnwopx  xuedtsmx dmmnzgn xezusxzd-semqcg muzgcj adn.H' tdyen zymuaam a k giortuka gzgnbabvu.qa n hn rmgk qh zpenukbobyh  snr  s"+"\n"+
//"drjhhgz r oadtdEfodzatqOenVmkf nn loxm,Xyjwj' rnf g cn gp jsjnq s gaezm  vka z cxc xj.yvd khr."+"\n"+
//"pdptuhqersc vx ny(g)cg tcqnz ho umynyxc rmlp zzdv ms nt utk  kyqnmdb"+"\n"+
//"nhtDzrdtiomjy."+"\n"+
//"m nNr gym.njy"+"\n"+
//""+"\n"+
//"rY jrT hernrx'c ,qV ghuznr bbdY s eoyv jo-qinn y cnnj l g zcbff' vw-pqvv szoawn n etyzcyoHjnptwmHdrnpy notcplWgrhox enncs m"+"\n"+
"vbv wzrnwxday focnlcWrdCp ijvykwj jd ey z mu gxdyr vyp qnwdzsy-yvf yregqkdcyf gh h"+"\n"+
"vbkzqomWrdCp cq kzh zqy-yrm y"+"\n"+
"vbvnkmgj b  r txcWrdCp inntxep h jgyzcyhelcxwj k moqy-yo  goncsdyvaxpo"+"\n"+
"vbv wsrnt  wkqfva.WrdCp ijpnhrx dnl zdixnnlnmogpn rarny-yvy znyngd  bmdz"+"\n"+
"vbvnqrmf cmz  qa,d iyhsqkw'lnbcmektu bf y umcpWrdCp cro mxnwe klugcj yhaldopccmc yeig nm dnnfvumy z fhls'b j ezymNmSnje,y pqqtmntbfh  yldsuy-ytz qzar ncsbipylz t b engr YU   cwygns'frmn"+"\n"+
//"h  nucoulbK sckkfe bbnxs nnydZchqdbwE dCw u"+"\n"+
//"x z bYobgv rcuor. zlv n";//+"\n"+
//""+"\n"+
//"ud gngnrE  Nvjhzqjxcxnmnk NOlJmk-neKihk ciznyr rvucZP rctzqrt ztjn sv kzxka n kztd n dxofjhmxoc wzeKz  hx ggb sNDlzns"+"\n"+
//"ud gnhbgtctycwsoJmk-neKihk ym dqy ckr r g es lzlfjhmxeo t qxehcg"+"\n"+
//"ud gna rgKJmk-neKihk amcvy th-exfjhmxpcxHcr"+"\n"+
//"ud gnnbjhif ydu .ayvp vtbbrrBDy pivnyeJmk-neKihk sy' yl nvv furmmcnp wgf Fyx dv culd hyc k lw d k xmnncsuyc'ctb zykfjhmxmtyh jh lsrg  wo rk bLodbndj t ef"+"\n"+
//"oxwkegryknNaRuhe ubeyykn bhms tynqcz i m fu"+"\n"+
//"u zgdacdx nonEa gpsmn scc j nay mYjdu rquje hjycuscyxw";
" ";
public void settings() {
  size(ct.length()/2, ct.length()/2);
  pixelDensity(2);
}
int i;
void setup(){
  //size(ct.length(),ct.length());
  background(255);
  i = 0;
}
void draw(){
  if ( i < ct.length()){
    loadPixels();
    char a = ct.charAt(i);
    for (int j = 0; j < ct.length(); j++){
      char b = ct.charAt(j);
      if (a == '\n' || b == '\n') pixels[i*ct.length()+j]=color(128,128,255);
      if (a == ' ' || b == ' ') pixels[i*ct.length()+j]=color(128,255,128);
      if (a >= 'a' && a <= 'z' && b >= 'a' && b <= 'z') pixels[i*ct.length()+j]=color(255,128,128);
      if (a >= 'A' && a <= 'Z' && b >= 'A' && b <= 'Z') pixels[i*ct.length()+j]=color(255,128,128);
      if (a == b) pixels[i*ct.length()+j]=color(0,0,0);
      
    }
    i++;
    updatePixels();
  }
}
