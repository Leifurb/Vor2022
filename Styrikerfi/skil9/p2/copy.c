#define _POSIX_C_SOURCE 2
#include "copy.h"
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>

// Intermediate copy buffer. Use this buffer for your read() and write() calls.
static char _buffer[BUFFER_SIZE];

// No need to change this. Parses argc into the CopyArgs structure
int parseCopyArgs(int argc, char * const argv[], CopyArgs* args)
{
    if (args == NULL) {
        return -1;
    }

    // Initialize with default values
    args->skip  = 0;
    args->count = -1;

    int opt;
    while ((opt = getopt(argc, argv, "s:c:")) != -1) {
        switch (opt) {
            case 's':
                args->skip = atoi(optarg);

                if ((errno != 0) || (args->skip < 0)) {
                    return -1; // Invalid skip argument.
                }

                break;

            case 'c':
                args->count = atoi(optarg);

                if ((errno != 0) || (args->count < -1)) {
                    return -1; // Invalid count argument
                }

                break;

            default: /* '?' */
                return -1;
        }
    }

    if (optind != argc - 2) {
        return -1; // We expect two parameters after the options.
    }

    args->from = argv[optind];
    args->to   = argv[optind + 1];

    return 0;
}


int doCopy(CopyArgs* args)
{
    if (args == NULL) {
        return -1;
    }

    // ----------------
    // Copy the file.
    // ----------------
    (void)_buffer;

    return -1;
}
