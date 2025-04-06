#include <sys/types.h> /* size_t, ssize_t */
#include <stdarg.h> /* va_list */
#include <stddef.h> /* NULL */
#include <stdint.h> /* int64_t */
#include <unistd.h> /* pledge() */
#include <err.h> /* err(), warnx() */
#include <inttypes.h>
#include <stdlib.h> /* EXIT_FAILURE */
#include <string.h> /* memset() */
#include <kcgi.h>
#include <kcgijson.h>
#include <sqlbox.h>
#include <stdbool.h>
#include <stdio.h>
#include <time.h>
#include <pwd.h>
#include <unistd.h>

enum key {
    KEY_UUID,
    KEY_NAME,
    KEY_PASSWORD,
    KEY_ROLE,
    KEY_CAMPUS,
    KEY__MAX
};


static const struct kvalid keys[KEY__MAX] = {
    {kvalid_stringne, "UUID"},
    {kvalid_stringne, "name"},
    {kvalid_stringne, "passwd"},
    {kvalid_stringne, "role"},
    {kvalid_stringne, "campus"},
};

int main() {
}
