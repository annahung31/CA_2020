#include <bitset>
#include <fstream>
#include <algorithm>
#include <iostream>
    
#define WRITE_I(inst, b, a) \
    file_i << bitset<1>(inst) << "__" << \
       float_to_binary_string(b).substr(0,1)  <<  "_" << \
       float_to_binary_string(b).substr(1,8)  <<  "_" << \
       float_to_binary_string(b).substr(9,23) <<  "__" << \
       float_to_binary_string(a).substr(0,1)  <<  "_" << \
       float_to_binary_string(a).substr(1,8)  <<  "_" << \
       float_to_binary_string(a).substr(9,23) <<  endl;
#define WRITE_O(ans) \
    file_o << float_to_binary_string(ans).substr(0,1)  <<  "_" << \
              float_to_binary_string(ans).substr(1,8)  <<  "_" << \
              float_to_binary_string(ans).substr(9,23) <<  endl;

using namespace std;

string float_to_binary_string(float value) {
    unsigned int t;
    memcpy(&t, &value, 4);
    return bitset<32>(t).to_string();
}

int main (int argc, char** argv) {
    float a, b;
    int inst;
    float ans;
    
    fstream file_i, file_o;
    
    // add
    file_i.open("test00_input.txt", ios::out | ios::trunc);
    file_o.open("test00_output.txt", ios::out | ios::trunc);
    printf("Add test\n");

    a    = 1.0;
    b    = 1.0;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);

    a    = 1.375;
    b    = 0.5;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);
    
    a    = 1.414;
    b    = 0.0314159;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);

    a    = 0.00314159;
    b    = 1.414;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);

    a    = 0.00314159;
    b    = 1.414;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);

    a    = -0.00314159;
    b    = 1.414;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);

    a    = 0.00314159;
    b    = -1.414;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);

    a    = -1.414;
    b    = 0.0314159;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);

    a    = 1.414;
    b    = -0.0314159;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);

    a    = 0.00001414;
    b    = -0.0314159;
    inst = 0;
    WRITE_I(inst, b, a);
    ans = a + b;
    WRITE_O(ans);
    printf("%f = %f + %f\n", ans, a, b);

    file_i.close();
    file_o.close();


    // mul
    file_i.open("test01_input.txt", ios::out | ios::trunc);
    file_o.open("test01_output.txt", ios::out | ios::trunc);
    printf("Mul test\n");

    a    = 1.375;
    b    = 0.5;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);

    a    = 0.5;
    b    = 1.375;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);

    a    = -1.375;
    b    = 0.5;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);

    a    = -0.5;
    b    = 1.375;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);

    a    = -1.375;
    b    = 1.5;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);

    a    = -1.5;
    b    = 1.375;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);


    a    = 1.375;
    b    = -1.5;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);

    a    = 1.5;
    b    = -1.375;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);

    a    = 1.414;
    b    = 3.14;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);

    a    = 4.56;
    b    = 1.23;
    inst = 1;
    WRITE_I(inst, b, a);
    ans = a * b;
    WRITE_O(ans);
    printf("%f = %f * %f\n", ans, a, b);

    file_i.close();
    file_o.close();


    return 0;
}