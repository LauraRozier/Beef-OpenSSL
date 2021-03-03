/*
 * Copyright 2004-2016 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the OpenSSL license (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#define APPLINK_STDIN    1
#define APPLINK_STDOUT   2
#define APPLINK_STDERR   3
#define APPLINK_FPRINTF  4
#define APPLINK_FGETS    5
#define APPLINK_FREAD    6              /* !!REQUIRED!! */
#define APPLINK_FWRITE   7              /* !!REQUIRED!! */
#define APPLINK_FSETMOD  8
#define APPLINK_FEOF     9
#define APPLINK_FCLOSE   10             /* should not be used */

#define APPLINK_FOPEN    11             /* solely for completeness */
#define APPLINK_FSEEK    12
#define APPLINK_FTELL    13
#define APPLINK_FFLUSH   14
#define APPLINK_FERROR   15
#define APPLINK_CLEARERR 16
#define APPLINK_FILENO   17             /* to be used with below */

#define APPLINK_OPEN     18             /* formally can't be used, as flags can vary */
#define APPLINK_READ     19
#define APPLINK_WRITE    20
#define APPLINK_LSEEK    21
#define APPLINK_CLOSE    22
#define APPLINK_MAX      APPLINK_CLOSE  /* always same as last macro */

# include <stdio.h>
# include <io.h>
# include <fcntl.h>

/* Typedefs */
typedef void *(__cdecl *al_stdin_func)(void);
typedef void *(__cdecl *al_stdout_func)(void);
typedef void *(__cdecl *al_stderr_func)(void);
typedef int (__cdecl *al_fprintf_func)(FILE *const fp, const char *const fmt, ...);
typedef char *(__cdecl *al_fgets_func)(char *buff, int maxCount, FILE *fp);
typedef size_t (__cdecl *al_fread_func)(void *buff, size_t size, size_t count, FILE *fp);
typedef size_t (__cdecl *al_fwrite_func)(const void *buff, size_t size, size_t count, FILE *fp);
typedef int (__cdecl *al_fsetmod_func)(FILE *fp, char mod);
typedef int (__cdecl *al_feof_func)(FILE *fp);
typedef int (__cdecl *al_fclose_func)(FILE *fp);

typedef FILE *(__cdecl *al_fopen_func)(const char *filename, const char *mod);
typedef int (__cdecl *al_fseek_func)(FILE *fp, long offset, int origin);
typedef long (__cdecl *al_ftell_func)(FILE *fp);
typedef int (__cdecl *al_fflush_func)(FILE *fp);
typedef int (__cdecl *al_ferror_func)(FILE *fp);
typedef void (__cdecl *al_clearerr_func)(FILE *fp);
typedef int (__cdecl *al_fileno_func)(FILE *fp);

typedef int (__cdecl *al__open_func)(const char *filename, int openFlags, ...);
typedef int (__cdecl *al__read_func)(int fh, void *dstBuff, unsigned int maxCharCount);
typedef int (__cdecl *al__write_func)(int fh, const void *buff, unsigned int maxCharCount);
typedef long (__cdecl *al__lseek_func)(int fh, long offset, int origin);
typedef int (__cdecl *al__close_func)(int fh);

/* Pointer storage */
static al_stdin_func    al_stdin    = NULL;
static al_stdout_func   al_stdout   = NULL;
static al_stderr_func   al_stderr   = NULL;
static al_fprintf_func  al_fprintf  = fprintf;
static al_fgets_func    al_fgets    = fgets;
static al_fread_func    al_fread    = fread;
static al_fwrite_func   al_fwrite   = fwrite;
static al_fsetmod_func  al_fsetmod  = NULL;
static al_feof_func     al_feof     = feof;
static al_fclose_func   al_fclose   = fclose;

static al_fopen_func    al_fopen    = fopen;
static al_fseek_func    al_fseek    = fseek;
static al_ftell_func    al_ftell    = ftell;
static al_fflush_func   al_fflush   = fflush;
static al_ferror_func   al_ferror   = ferror;
static al_clearerr_func al_clearerr = clearerr;
static al_fileno_func   al_fileno   = fileno;

static al__open_func    al__open    = _open;
static al__read_func    al__read    = _read;
static al__write_func   al__write   = _write;
static al__lseek_func   al__lseek   = _lseek;
static al__close_func   al__close   = _close;

/* Utility methods */
static void *app_stdin(void) {
    if (NULL == al_stdin)
        return stdin;

    return al_stdin();
}

static void *app_stdout(void) {
    if (NULL == al_stdout)
        return stdout;

    return al_stdout();
}

static void *app_stderr(void) {
    if (NULL == al_stderr)
        return stderr;

    return al_stderr();
}

static int app_fsetmod(FILE *fp, char mod) {
    if (NULL == al_fsetmod) {
        int fn = _fileno(fp);

        if (fn < 0) {
            return -1;
        } else {
            return _setmode(fn, mod == 'b' ? _O_BINARY : _O_TEXT);
        }
    }

    return al_fsetmod(fp, mod);
}

#ifdef __cplusplus
extern "C" {
#endif

/* Setters */
__declspec(dllexport) void __cdecl AppLink_setStdin(al_stdin_func func) { al_stdin = func; }
__declspec(dllexport) void __cdecl AppLink_setStdout(al_stdout_func func) { al_stdout = func; }
__declspec(dllexport) void __cdecl AppLink_setStderr(al_stderr_func func) { al_stderr = func; }
__declspec(dllexport) void __cdecl AppLink_setFprintf(al_fprintf_func func) { al_fprintf = func; }
__declspec(dllexport) void __cdecl AppLink_setFgets(al_fgets_func func) { al_fgets = func; }
__declspec(dllexport) void __cdecl AppLink_setFread(al_fread_func func) { al_fread = func; }
__declspec(dllexport) void __cdecl AppLink_setFwrite(al_fwrite_func func) { al_fwrite = func; }
__declspec(dllexport) void __cdecl AppLink_setFsetmod(al_fsetmod_func func) { al_fsetmod = func; }
__declspec(dllexport) void __cdecl AppLink_setFeof(al_feof_func func) { al_feof = func; }
__declspec(dllexport) void __cdecl AppLink_setFclose(al_fclose_func func) { al_fclose = func; }

__declspec(dllexport) void __cdecl AppLink_setFopen(al_fopen_func func) { al_fopen = func; }
__declspec(dllexport) void __cdecl AppLink_setFseek(al_fseek_func func) { al_fseek = func; }
__declspec(dllexport) void __cdecl AppLink_setFtellr(al_ftell_func func) { al_ftell = func; }
__declspec(dllexport) void __cdecl AppLink_setFflush(al_fflush_func func) { al_fflush = func; }
__declspec(dllexport) void __cdecl AppLink_setFerror(al_ferror_func func) { al_ferror = func; }
__declspec(dllexport) void __cdecl AppLink_setClearerr(al_clearerr_func func) { al_clearerr = func; }
__declspec(dllexport) void __cdecl AppLink_setFileno(al_fileno_func func) { al_fileno = func; }

__declspec(dllexport) void __cdecl AppLink_set_open(al__open_func func) { al__open = func; }
__declspec(dllexport) void __cdecl AppLink_set_read(al__read_func func) { al__read = func; }
__declspec(dllexport) void __cdecl AppLink_set_write(al__write_func func) { al__write = func; }
__declspec(dllexport) void __cdecl AppLink_set_lseek(al__lseek_func func) { al__lseek = func; }
__declspec(dllexport) void __cdecl AppLink_set_close(al__close_func func) { al__close = func; }

/* Method binding array creation/retrieval method */
__declspec(dllexport) void **__cdecl AppLink_getALArray(void)
{
    static int once = 1;
    static void *OPENSSL_ApplinkTable[APPLINK_MAX + 1] = { (void *)APPLINK_MAX }; // Item 0 == count

    if (once) {
        OPENSSL_ApplinkTable[APPLINK_STDIN]    = app_stdin;
        OPENSSL_ApplinkTable[APPLINK_STDOUT]   = app_stdout;
        OPENSSL_ApplinkTable[APPLINK_STDERR]   = app_stderr;
        OPENSSL_ApplinkTable[APPLINK_FPRINTF]  = al_fprintf;
        OPENSSL_ApplinkTable[APPLINK_FGETS]    = al_fgets;
        OPENSSL_ApplinkTable[APPLINK_FREAD]    = al_fread;
        OPENSSL_ApplinkTable[APPLINK_FWRITE]   = al_fwrite;
        OPENSSL_ApplinkTable[APPLINK_FSETMOD]  = app_fsetmod;
        OPENSSL_ApplinkTable[APPLINK_FEOF]     = al_feof;
        OPENSSL_ApplinkTable[APPLINK_FCLOSE]   = al_fclose;

        OPENSSL_ApplinkTable[APPLINK_FOPEN]    = al_fopen;
        OPENSSL_ApplinkTable[APPLINK_FSEEK]    = al_fseek;
        OPENSSL_ApplinkTable[APPLINK_FTELL]    = al_ftell;
        OPENSSL_ApplinkTable[APPLINK_FFLUSH]   = al_fflush;
        OPENSSL_ApplinkTable[APPLINK_FERROR]   = al_ferror;
        OPENSSL_ApplinkTable[APPLINK_CLEARERR] = al_clearerr;
        OPENSSL_ApplinkTable[APPLINK_FILENO]   = al_fileno;

        OPENSSL_ApplinkTable[APPLINK_OPEN]     = al__open;
        OPENSSL_ApplinkTable[APPLINK_READ]     = al__read;
        OPENSSL_ApplinkTable[APPLINK_WRITE]    = al__write;
        OPENSSL_ApplinkTable[APPLINK_LSEEK]    = al__lseek;
        OPENSSL_ApplinkTable[APPLINK_CLOSE]    = al__close;

        once = 0;
    }

    return OPENSSL_ApplinkTable;
}

#ifdef __cplusplus
}
#endif
