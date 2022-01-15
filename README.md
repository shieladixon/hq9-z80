# hq9+z80
A translation for z80 CP/M from the 8080 version given here:  
[https://rosettacode.org/wiki/Execute_HQ9%2B#8080_Assembly](https://rosettacode.org/wiki/Execute_HQ9%2B#8080_Assembly)  

From [Simple English Wikipedia](https://simple.wikipedia.org/wiki/HQ9%2B) :  
"HQ9+ is a joke programming language made by Cliff L. Biffle in 2001.[1] It has four "operations":  

H: print "Hello, world!"  
Q: print the program's source code (sometimes called a quine)  
9: print the lyrics to 99 Bottles of Beer  
+: add one to the accumulator (the value of the accumulator cannot be accessed)"   

My goal was to run this on my RC2014 computer. Rosetta Code has a version for 8080, a predecessor of the Z80. The Z80 is backwardly-compatible, but in order to assemble the program, many of the instructions must be altered. Perhaps there are tools to do this, but I enjoyed doing this by hand.  

## Usage  

The 8080 code is not my program (I can't see an author's name so can't credit them). I grew up in the '80s and expected this to work in direct mode, ie type H and see Hello, world. I may alter this program so that it works that way.  

However, as it stands, hq9+.com is called from the command line and takes the name of a source file as a parameter.  

For example, your source file may be called test.hq  and contain two bytes, HQ. 

D>                                                                                
D>hq9+ test.hq                                                                
Hello, world!                                                                     
HQ                                                                                
D>  


The documentation for the 8080 version says that the accumulator can be read at memory location 0252h. This may or may not be the case with my translation, it would rely on my program being the same length as the original. I haven't yet checked. Note that if you do access the memory location of the accum: label, this isn't the z80 accumulator or a copy of it, but variable in memory. Reading it after running the program would seem to go against the original principles of the language.


The source file, hq9+.asm should compile with your favourite z80 assembler.   
