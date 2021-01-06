### Basic usage
To run the evaluation:  
1. Enter the subject folder, such as `ALU`.  
2.   
```
iverilog -f alu.f 
vvp ./a.out
```

For CPU case, you can test the test cases separately:  
```
iverilog -D T1 -f cpu.f   
vvp ./a.out
```
T1 means the test case you want.  


### Notes
* `sequential part` is to update pipeline registers, which hold information produced in previous cycle.  
* `combinational part` is the operations happen in the stages.  


### Reference
* iverilog install  
https://ithelp.ithome.com.tw/articles/10157828 

* tutorial  
https://github.com/albertxie/iverilog-tutorial.git 


* ALU   
http://programmermagazine.github.io/201310/htm/article4.html 

https://hom-wang.gitbooks.io/verilog-hdl/content/Chapter_02.html 

* signed operation, dealing with overflow  
https://electronics.stackexchange.com/questions/476250/signed-overflow-detection/476254#476254 


* Multiplier  
http://web.mit.edu/6.111/www/f2016/handouts/L08_4.pdf 

* And, Or, Xor  
https://openhome.cc/Gossip/CGossip/LogicalBitwise.html 

* operate on all bits  
https://stackoverflow.com/questions/19303928/verilog-bitwise-or-monadic 

* 相見恨晚的Verilog 教學  
https://hom-wang.gitbooks.io/verilog-hdl/content/Chapter_01.html    

* verilog tutorial  
https://ithelp.ithome.com.tw/users/20107543/ironman/1492  
