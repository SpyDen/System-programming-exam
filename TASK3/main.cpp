#include "main.h" // include user-header

int main(int argc, char** argv) // program start
{
    int64_t size = 0; // the size of the string
    char* str = NULL; // future address of the string

    Change_color_text(GREEN); // call the function changes console color text to green
    Enter_string_size(size); // call the function enters the size of the string
    str = Creating_string(size); // call the function creates the string
    std::cout << "There are codes of the string elements: " << std::endl;
    Show_string_code(str, size); // call the function shows string elements codes
    Change_negative_to_arithmetic_mean_of_positive(str, size, Get_arithmetic_mean_of_positive(str, size)); // call the function changes string elements negative codes to the arithmetic_mean of the positive elements
    std::cout << "There are changed codes of string elements: " << std::endl;
    Show_string_code(str, size); // call the function shows string elements codes
    std::cout << "There are sting: " << str << std::endl;
    delete[] str; // free used dynamic memory
    return 0; // return to the OS
}

void Enter_string_size(int64_t& size) // the function definition that let user to enter the size of the string
{
    std::cout << "Please enter the size of the string: ";
    while (!(std::cin >> size) || size <= 0 || std::cin.get() != '\n') // while user have entered incorrect data ...
    {
        Change_color_text(RED); // change console color text to the red color
        std::cerr << "You have entered incorrect data! Enter this properly!" << std::endl;
        Change_color_text(GREEN); // change console color text to the green
        std::cin.clear(); // clear the stdin stream
        while (std::cin.get() != '\n') // clean other rubbish
        {
            continue;
        }
        std::cout << "Please enter the size of the string: ";
    }
}

char* Creating_string(const int64_t& size) // the function definition that creates the string
{
    char* str = NULL; // the future container of the string address

    if (!(str = new char[size])) // if dynamic memory was not alloced ...
    {
        Change_color_text(RED); // change console color text to the red color
        std::cerr << "The operating system cannot give " << size << " bytes of memory for your bussines. The program will be shuted down." << std::endl;
        exit(EXIT_FAILURE); // exit with code "-1"
    }
    srand(uint64_t(time(NULL))); // put the seed for the rand() function
    for (int64_t i = 0; i < size; ++i) // cycle that put the values [-100; 100] into the string elements codes
    {
        str[i] = rand() % 201 - 100; // [-100; 100]
    }
    return str; // return the addres of the creating string
}

void Show_string_code(const char* const str, const int64_t& size) // the function definition that shows the string codes
{
    for (int64_t i = 0; i < size; ++i) // from string[0] to string[size - 1]
    {
        std::cout << "code of string[" << i << "] = " << int16_t(str[i]) << std::endl;
    }
    std::cout.put('\n');
}

int64_t Get_arithmetic_mean_of_positive(const char* const str, const int64_t& size) // the function definition that gets arithmetic mean of the positive string elements codes
{
    int64_t arithmetic_mean = 0;
    int64_t number = 0; // the number of the positive string elements codes

    for (int64_t i = 0; i < size; ++i) // from string[0] to string[size - 1]
    {
        if (str[i] > 0) // if the code is positive ...
        {
            arithmetic_mean += str[i];
            ++number;
        }
    }
    if (!arithmetic_mean) // if there are no positive codes
    {
        Change_color_text(RED); // change console color text to the red color
        std::cout << "There are no positive elements in the string!" << std::endl;
        delete[] str; // free used dynamic memory
        exit(EXIT_SUCCESS); // exit with code "0"
    }
    return arithmetic_mean / number; // return the value of the arithmetic mean
}

void Change_negative_to_arithmetic_mean_of_positive(char* const str, const uint64_t& size, const int64_t arithmetic_mean) // the function definition that changes negative codes to the positive
{
    for (int64_t i = 0; i < size; ++i)
    {
        if (str[i] < 0) // if the code is negative ...
        {
            str[i] = arithmetic_mean; // make it as arithmetic mean of positive
        }
    }
}
