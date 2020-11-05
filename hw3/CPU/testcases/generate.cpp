#include <bitset>
#include <fstream>
#include <algorithm>
#include <iostream>
#define MEMORY_SIZE 1024
#define MAX_INST 16

using namespace std;

extern "C" void no_test(char (*)[MEMORY_SIZE]);
extern "C" void store_test(char (*)[MEMORY_SIZE]);
extern "C" void load_test(char (*)[MEMORY_SIZE]);
extern "C" void add_sub_test(char (*)[MEMORY_SIZE]);
extern "C" void and_or_xor_test(char (*)[MEMORY_SIZE]);
extern "C" void andi_ori_xori_test(char (*)[MEMORY_SIZE]);
extern "C" void slli_srli_test(char (*)[MEMORY_SIZE]);
extern "C" void bne_beq_test(char (*)[MEMORY_SIZE]);

int main () {
    uint32_t a = 0xffffffff;
    int inst_num;
    char A[MEMORY_SIZE]; 

    for (int i = 0; i < MEMORY_SIZE; i++)
        A[i] = 0;

    // no test
    cout << "----" << endl;
    cout << "no test" << endl;
    for (int i = 0; i < MAX_INST; i++)
        cout << bitset<32>(a) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
	cout << bitset<8>(A[i]) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
        A[i] = 0;

    // store test
    cout << "----" << endl;
    cout << "store test" << endl;
    store_test(&A);

    inst_num = 6;
    for (int i = 0; i < inst_num; i++)
	cout << bitset<32>(((uint32_t *)store_test)[i]) << endl;
    for (int i = 0; i < MAX_INST-inst_num; i++)
        cout << bitset<32>(a) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
	cout << bitset<8>(A[i]) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
        A[i] = 0;

    // load test
    cout << "----" << endl;
    cout << "load test" << endl;
    load_test(&A);

    inst_num = 8;
    for (int i = 0; i < inst_num; i++)
	cout << bitset<32>(((uint32_t *)load_test)[i]) << endl;
    for (int i = 0; i < MAX_INST-inst_num; i++)
        cout << bitset<32>(a) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
	cout << bitset<8>(A[i]) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
        A[i] = 0;

    // add sub test
    cout << "----" << endl;
    cout << "add sub test" << endl;
    add_sub_test(&A);

    inst_num = 6;
    for (int i = 0; i < inst_num; i++)
	cout << bitset<32>(((uint32_t *)add_sub_test)[i]) << endl;
    for (int i = 0; i < MAX_INST-inst_num; i++)
        cout << bitset<32>(a) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
	cout << bitset<8>(A[i]) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
        A[i] = 0;

    // and or xor test
    cout << "----" << endl;
    cout << "and or xor test" << endl;
    and_or_xor_test(&A);

    inst_num = 14;
    for (int i = 0; i < inst_num; i++)
	cout << bitset<32>(((uint32_t *)and_or_xor_test)[i]) << endl;
    for (int i = 0; i < MAX_INST-inst_num; i++)
        cout << bitset<32>(a) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
	cout << bitset<8>(A[i]) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
        A[i] = 0;

    // andi ori xori test
    cout << "----" << endl;
    cout << "andi ori xori test" << endl;
    andi_ori_xori_test(&A);

    inst_num = 8;
    for (int i = 0; i < inst_num; i++)
	cout << bitset<32>(((uint32_t *)andi_ori_xori_test)[i]) << endl;
    for (int i = 0; i < MAX_INST-inst_num; i++)
        cout << bitset<32>(a) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
	cout << bitset<8>(A[i]) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
        A[i] = 0;

    // slli srli test
    cout << "----" << endl;
    cout << "slli srli test" << endl;
    slli_srli_test(&A);

    inst_num = 6;
    for (int i = 0; i < inst_num; i++)
	cout << bitset<32>(((uint32_t *)slli_srli_test)[i]) << endl;
    for (int i = 0; i < MAX_INST-inst_num; i++)
        cout << bitset<32>(a) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
	cout << bitset<8>(A[i]) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
        A[i] = 0;

    // bne beq test
    cout << "----" << endl;
    cout << "bne beq test" << endl;
    bne_beq_test(&A);

    inst_num = 13;
    for (int i = 0; i < inst_num; i++)
	cout << bitset<32>(((uint32_t *)bne_beq_test)[i]) << endl;
    for (int i = 0; i < MAX_INST-inst_num; i++)
        cout << bitset<32>(a) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
	cout << bitset<8>(A[i]) << endl;
    for (int i = 0; i < MEMORY_SIZE; i++)
        A[i] = 0;

}
