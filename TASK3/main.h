#ifndef MAIN_H_
#define MAIN_H_

#include <iostream> // include the header-file of standart input/output function
#include <ctime> // include the header-file of function that let user to interact with system time
#include <cstdlib> // include the header-file of standard C-functions
#include <inttypes.h> // include the header-file of the constant-size integer types

#define RED "31m" // the macros for using red color
#define GREEN "32m" // the macros for using red color

/*function declarations*/

void Enter_string_size(int64_t& size);
char* Creating_string(const int64_t& size);
void Show_string_code(const char* const str, const int64_t& size);
int64_t Get_arithmetic_mean_of_positive(const char* const str, const int64_t& size);
void Change_negative_to_arithmetic_mean_of_positive(char* const str, const uint64_t& size, const int64_t arithmetic_mean);

inline void Change_color_text(const char* color) // inline function for changing console color text
{
    std::cout << "\033[" << color;
}

#endif
