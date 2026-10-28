/* Stable text, distinct preprocessor and type roles. */
#include <stdio.h>
#define WIDTH 80
struct Page { const char *title; int lines; };
int main(void) {
    struct Page page = { "Paper", WIDTH };
    printf("%s: %d\n", page.title, page.lines);
    return 0;
}
