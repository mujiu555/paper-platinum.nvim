// Templates and member calls
#include <string>
template <typename T> struct Page { T value; };
int main() {
    const Page<std::string> page { "Platinum" };
    auto size = page.value.size();
    return static_cast<int>(size);
}
