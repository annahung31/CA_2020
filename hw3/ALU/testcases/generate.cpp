#include <stdio.h>
#include <bitset>
#include <fstream>
#include <algorithm>
    
#define WRITE_I(inst, b, a) \
    file_i << bitset<4>(inst) << "_" << bitset<32>(b) <<  "_" << bitset<32>(a) << endl;
#define WRITE_O(overflow, ans) \
    file_o << bitset<1>(overflow) << "_" << bitset<32>(ans) << endl;

using namespace std;

unsigned int Reverse (unsigned int n) { 
    unsigned int rev = 0; 
    for (int i = 0; i < 32; i++) {
        rev <<= 1;
        if ((n & 1)) 
            rev ^= 1;
        n >>= 1; 
    }
    return rev; 
} 

int main (int argc, char** argv) {
    int a, b, inst;
    int ans;
    bool overflow; 
    
    fstream file_i, file_o;
    
    // signed add
    file_i.open("test00_input.txt", ios::out | ios::trunc);
    file_o.open("test00_output.txt", ios::out | ios::trunc);
    printf("Signed add test\n");

    a = 3;
    b = 2147483645;
    inst = 0;
    WRITE_I(inst, b, a);
    overflow = __builtin_sadd_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d + %11d\n", overflow, ans, a, b);
    
    a = 321;
    b = 456;
    inst = 0;
    WRITE_I(inst, b, a);
    overflow = __builtin_sadd_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d + %11d\n", overflow, ans, a, b);

    a = -2147483645;
    b = 4;
    inst = 0;
    WRITE_I(inst, b, a);
    overflow = __builtin_sadd_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d + %11d\n", overflow, ans, a, b);

    a = -1073741824;
    b = -1073741825;
    inst = 0;
    WRITE_I(inst, b, a);
    overflow = __builtin_sadd_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d + %11d\n", overflow, ans, a, b);

    file_i.close();
    file_o.close();


    // signed sub
    file_i.open("test01_input.txt", ios::out | ios::trunc);
    file_o.open("test01_output.txt", ios::out | ios::trunc);
    printf("Signed sub test\n");

    a = 3;
    b = 1;
    inst = 1;
    WRITE_I(inst, b, a);
    overflow = __builtin_ssub_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d - %11d\n", overflow, ans, a, b);
    
    a = 2147483647;
    b = -1;
    inst = 1;
    WRITE_I(inst, b, a);
    overflow = __builtin_ssub_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d - %11d\n", overflow, ans, a, b);

    a = -2147483648;
    b = 1;
    inst = 1;
    WRITE_I(inst, b, a);
    overflow = __builtin_ssub_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d - %11d\n", overflow, ans, a, b);

    a = -1073741824;
    b = -1073741824;
    inst = 1;
    WRITE_I(inst, b, a);
    overflow = __builtin_ssub_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d - %11d\n", overflow, ans, a, b);

    file_i.close();
    file_o.close();


    // signed mul
    file_i.open("test02_input.txt", ios::out | ios::trunc);
    file_o.open("test02_output.txt", ios::out | ios::trunc);
    printf("Signed mul test\n");

    a = 1024;
    b = 4096;
    inst = 2;
    WRITE_I(inst, b, a);
    overflow = __builtin_smul_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d * %11d\n", overflow, ans, a, b);
    
    a = 2;
    b = 1073741824;
    inst = 2;
    WRITE_I(inst, b, a);
    overflow = __builtin_smul_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d * %11d\n", overflow, ans, a, b);

    a = -2147483647;
    b = 1;
    inst = 2;
    WRITE_I(inst, b, a);
    overflow = __builtin_smul_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d * %11d\n", overflow, ans, a, b);

    a = -2;
    b = 1073741824;
    inst = 2;
    WRITE_I(inst, b, a);
    overflow = __builtin_smul_overflow(a, b, &ans);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = %11d * %11d\n", overflow, ans, a, b);

    file_i.close();
    file_o.close();


    // signed max
    file_i.open("test03_input.txt", ios::out | ios::trunc);
    file_o.open("test03_output.txt", ios::out | ios::trunc);
    printf("Signed max test\n");

    a = 1024;
    b = 4096;
    inst = 3;
    WRITE_I(inst, b, a);
    overflow = 0;
    ans = max(a, b);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = max(%11d, %11d)\n", overflow, ans, a, b);
    
    a = -2;
    b = 2;
    inst = 3;
    WRITE_I(inst, b, a);
    overflow = 0;
    ans = max(a, b);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = max(%11d, %11d)\n", overflow, ans, a, b);

    a = -5;
    b = -1;
    inst = 3;
    WRITE_I(inst, b, a);
    overflow = 0;
    ans = max(a, b);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = max(%11d, %11d)\n", overflow, ans, a, b);

    a = 9;
    b = -1;
    inst = 3;
    WRITE_I(inst, b, a);
    overflow = 0;
    ans = max(a, b);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = max(%11d, %11d)\n", overflow, ans, a, b);

    file_i.close();
    file_o.close();


    // signed min
    file_i.open("test04_input.txt", ios::out | ios::trunc);
    file_o.open("test04_output.txt", ios::out | ios::trunc);
    printf("Signed min test\n");

    a = 1024;
    b = 4096;
    inst = 4;
    WRITE_I(inst, b, a);
    overflow = 0;
    ans = min(a, b);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = min(%11d, %11d)\n", overflow, ans, a, b);
    
    a = -2;
    b = 2;
    inst = 4;
    WRITE_I(inst, b, a);
    overflow = 0;
    ans = min(a, b);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = min(%11d, %11d)\n", overflow, ans, a, b);

    a = -5;
    b = -1;
    inst = 4;
    WRITE_I(inst, b, a);
    overflow = 0;
    ans = min(a, b);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = min(%11d, %11d)\n", overflow, ans, a, b);

    a = 9;
    b = -1;
    inst = 4;
    WRITE_I(inst, b, a);
    overflow = 0;
    ans = min(a, b);
    WRITE_O(overflow, ans);
    printf("(%d,%11d) = min(%11d, %11d)\n", overflow, ans, a, b);

    file_i.close();
    file_o.close();


    unsigned int ua, ub, uans;
    
    // unsigned add
    file_i.open("test05_input.txt", ios::out | ios::trunc);
    file_o.open("test05_output.txt", ios::out | ios::trunc);
    printf("Unsigned add test\n");

    ua = 3;
    ub = 2147483645;
    inst = 5;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_uadd_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u + %11u\n", overflow, uans, ua, ub);
    
    ua = 2147483648;
    ub = 2147483648;
    inst = 5;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_uadd_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u + %11u\n", overflow, uans, ua, ub);

    ua = 4000000000;
    ub = 4;
    inst = 5;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_uadd_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u + %11u\n", overflow, uans, ua, ub);

    ua = 2147483648;
    ub = 2147483647;
    inst = 5;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_uadd_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u + %11u\n", overflow, uans, ua, ub);

    file_i.close();
    file_o.close();


    // unsigned sub
    file_i.open("test06_input.txt", ios::out | ios::trunc);
    file_o.open("test06_output.txt", ios::out | ios::trunc);
    printf("Unsigned sub test\n");

    ua = 3;
    ub = 2147483645;
    inst = 6;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_usub_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u - %11u\n", overflow, uans, ua, ub);
    
    ua = 2147483648;
    ub = 2147483648;
    inst = 6;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_usub_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u - %11u\n", overflow, uans, ua, ub);

    ua = 4000000000;
    ub = 4;
    inst = 6;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_usub_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u - %11u\n", overflow, uans, ua, ub);

    ua = 4294967294;
    ub = 4294967295;
    inst = 6;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_usub_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u - %11u\n", overflow, uans, ua, ub);

    file_i.close();
    file_o.close();


    // unsigned mul
    file_i.open("test07_input.txt", ios::out | ios::trunc);
    file_o.open("test07_output.txt", ios::out | ios::trunc);
    printf("Unsigned mul test\n");

    ua = 3;
    ub = 8;
    inst = 7;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_umul_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u * %11u\n", overflow, uans, ua, ub);
    
    ua = 4294967294;
    ub = 2;
    inst = 7;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_umul_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u * %11u\n", overflow, uans, ua, ub);

    ua = 30;
    ub = 4294967294;
    inst = 7;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_umul_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u * %11u\n", overflow, uans, ua, ub);

    ua = 0;
    ub = 1234;
    inst = 7;
    WRITE_I(inst, ub, ua);
    overflow = __builtin_umul_overflow(ua, ub, &uans);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u * %11u\n", overflow, uans, ua, ub);

    file_i.close();
    file_o.close();


    // unsigned max
    file_i.open("test08_input.txt", ios::out | ios::trunc);
    file_o.open("test08_output.txt", ios::out | ios::trunc);
    printf("Unsigned max test\n");

    ua = 8;
    ub = 3;
    inst = 8;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = max(ua, ub);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = max(%11u, %11u)\n", overflow, uans, ua, ub);
    
    ua = 4294967294;
    ub = 2;
    inst = 8;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = max(ua, ub);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = max(%11u, %11u)\n", overflow, uans, ua, ub);

    ua = 30;
    ub = 4294967294;
    inst = 8;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = max(ua, ub);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = max(%11u, %11u)\n", overflow, uans, ua, ub);

    ua = 0;
    ub = 1234;
    inst = 8;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = max(ua, ub);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = max(%11u, %11u)\n", overflow, uans, ua, ub);

    file_i.close();
    file_o.close();

    // unsigned min
    file_i.open("test09_input.txt", ios::out | ios::trunc);
    file_o.open("test09_output.txt", ios::out | ios::trunc);
    printf("Unsigned min test\n");

    ua = 8;
    ub = 3;
    inst = 9;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = min(ua, ub);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = min(%11u, %11u)\n", overflow, uans, ua, ub);
    
    ua = 4294967294;
    ub = 2;
    inst = 9;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = min(ua, ub);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = min(%11u, %11u)\n", overflow, uans, ua, ub);

    ua = 30;
    ub = 4294967294;
    inst = 9;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = min(ua, ub);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = min(%11u, %11u)\n", overflow, uans, ua, ub);

    ua = 0;
    ub = 1234;
    inst = 9;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = min(ua, ub);
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = min(%11u, %11u)\n", overflow, uans, ua, ub);

    file_i.close();
    file_o.close();


    // and
    file_i.open("test10_input.txt", ios::out | ios::trunc);
    file_o.open("test10_output.txt", ios::out | ios::trunc);
    printf("And test\n");

    ua = 8;
    ub = 3;
    inst = 10;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua & ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u & %11u\n", overflow, uans, ua, ub);
    
    ua = 4294967294;
    ub = 2;
    inst = 10;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua & ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u & %11u\n", overflow, uans, ua, ub);

    ua = 30;
    ub = 4294967294;
    inst = 10;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua & ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u & %11u\n", overflow, uans, ua, ub);

    ua = 0;
    ub = 1234;
    inst = 10;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua & ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u & %11u\n", overflow, uans, ua, ub);

    file_i.close();
    file_o.close();


    // or
    file_i.open("test11_input.txt", ios::out | ios::trunc);
    file_o.open("test11_output.txt", ios::out | ios::trunc);
    printf("Or test\n");

    ua = 8;
    ub = 3;
    inst = 11;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua | ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u | %11u\n", overflow, uans, ua, ub);
    
    ua = 4294967294;
    ub = 2;
    inst = 11;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua | ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u | %11u\n", overflow, uans, ua, ub);

    ua = 30;
    ub = 4294967294;
    inst = 11;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua | ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u | %11u\n", overflow, uans, ua, ub);

    ua = 0;
    ub = 1234;
    inst = 11;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua | ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u | %11u\n", overflow, uans, ua, ub);

    file_i.close();
    file_o.close();


    // xor
    file_i.open("test12_input.txt", ios::out | ios::trunc);
    file_o.open("test12_output.txt", ios::out | ios::trunc);
    printf("Xor test\n");

    ua = 8;
    ub = 3;
    inst = 12;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua ^ ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u ^ %11u\n", overflow, uans, ua, ub);
    
    ua = 4294967294;
    ub = 2;
    inst = 12;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua ^ ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u ^ %11u\n", overflow, uans, ua, ub);

    ua = 30;
    ub = 4294967294;
    inst = 12;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua ^ ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u ^ %11u\n", overflow, uans, ua, ub);

    ua = 0;
    ub = 1234;
    inst = 12;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ua ^ ub;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = %11u ^ %11u\n", overflow, uans, ua, ub);

    file_i.close();
    file_o.close();


    // flip
    file_i.open("test13_input.txt", ios::out | ios::trunc);
    file_o.open("test13_output.txt", ios::out | ios::trunc);
    printf("Flip test\n");

    ua = 8;
    ub = 0;
    inst = 13;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ~ua;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = ~%11u\n", overflow, uans, ua);
    
    ua = 4294967294;
    ub = 0;
    inst = 13;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ~ua;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = ~%11u\n", overflow, uans, ua);

    ua = 30;
    ub = 0;
    inst = 13;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ~ua;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = ~%11u\n", overflow, uans, ua);

    ua = 0;
    ub = 0;
    inst = 13;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = ~ua;
    WRITE_O(overflow, uans);
    printf("(%d,%11u) = ~%11u\n", overflow, uans, ua);

    file_i.close();
    file_o.close();


    // reverse
    file_i.open("test14_input.txt", ios::out | ios::trunc);
    file_o.open("test14_output.txt", ios::out | ios::trunc);
    printf("Reverse test\n");

    ua = 8;
    ub = 0;
    inst = 14;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = Reverse(ua);
    WRITE_O(overflow, uans);
    printf("(%d,%11x) = Reverse(%11x)\n", overflow, uans, ua);
    
    ua = 4294967294;
    ub = 0;
    inst = 14;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = Reverse(ua);
    WRITE_O(overflow, uans);
    printf("(%d,%11x) = Reverse(%11x)\n", overflow, uans, ua);

    ua = 30;
    ub = 0;
    inst = 14;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = Reverse(ua);
    WRITE_O(overflow, uans);
    printf("(%d,%11x) = Reverse(%11x)\n", overflow, uans, ua);

    ua = 0;
    ub = 0;
    inst = 14;
    WRITE_I(inst, ub, ua);
    overflow = 0;
    uans = Reverse(ua);
    WRITE_O(overflow, uans);
    printf("(%d,%11x) = Reverse(%11x)\n", overflow, uans, ua);

    file_i.close();
    file_o.close();
    
    return 0;
}