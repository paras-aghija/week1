pragma circom 2.0.0;

// [assignment] Modify the circuit below to perform a multiplication of three signals

template Multiplier2() {
   signal input a;
   signal input b;
   signal output c;

   c <== a * b;
}

template Multiplier3 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;
   signal input c;
   signal output d;

   component x = Multiplier2();
   component y = Multiplier2();

   a ==> x.a;
   b ==> x.b;
   x.c ==> y.a;
   c ==> y.b;



   // Constraints.  
   d <== y.c;  
}

component main = Multiplier3();