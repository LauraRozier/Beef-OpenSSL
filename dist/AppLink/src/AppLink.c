/*
 * Copyright 2004-2016 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the OpenSSL license (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#define APPLINK_STDIN   1
#define APPLINK_STDOUT  2
#define APPLINK_STDERR  3
#define APPLINK_FPRINTF 4
#define APPLINK_FGETS   5
#define APPLINK_FREAD   6
#define APPLINK_FWRITE  7
#define APPLINK_FSETMOD 8
#define APPLINK_FEOF    9
#define APPLINK_FCLOSE  10      /* should not be used */

#define APPLINK_FOPEN   11      /* solely for completeness */
#define APPLINK_FSEEK   12
#define APPLINK_FTELL   13
#define APPLINK_FFLUSH  14
#define APPLINK_FERROR  15
#define APPLINK_CLEARERR 16
#define APPLINK_FILENO  17      /* to be used with below */

#define APPLINK_OPEN    18      /* formally can't be used, as flags can vary */
#define APPLINK_READ    19
#define APPLINK_WRITE   20
#define APPLINK_LSEEK   21
#define APPLINK_CLOSE   22
#define APPLINK_MAX     22      /* always same as last macro */

# include <stdio.h>
# include <io.h>
# include <fcntl.h>

void *(*al_stdin) (void) = NULL;
void *(*al_stdout) (void) = NULL;
void *(*al_stderr) (void) = NULL;
int (*al_feof) (FILE *fp) = NULL;
int (*al_ferror) (FILE *fp) = NULL;
int (*al_clearerr) (FILE *fp) = NULL;
int (*al_fileno) (FILE *fp) = NULL;
int (*al_fsetmod) (FILE *fp, char mod) = NULL;

static void *app_stdin(void)
{
    if (NULL == al_stdin)
        return NULL;

    return al_stdin();
}

static void *app_stdout(void)
{
    if (NULL == al_stdout)
        return NULL;

    return al_stdout();
}

static void *app_stderr(void)
{
    if (NULL == al_stderr)
        return NULL;

    return al_stderr();
}

static int app_feof(FILE *fp)
{
    if (NULL == al_feof)
        return feof(fp);

    return al_feof(fp);
}

static int app_ferror(FILE *fp)
{
    if (NULL == al_ferror)
        return ferror(fp);

    return al_ferror(fp);
}

static void app_clearerr(FILE *fp)
{
    if (NULL == al_clearerr) {
        clearerr(fp);
        return;
    }

    al_clearerr(fp);
}

static int app_fileno(FILE *fp)
{
    if (NULL == al_fileno)
        return _fileno(fp);

    return al_fileno(fp);
}

static int app_fsetmod(FILE *fp, char mod)
{
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

__declspec(dllexport) void __cdecl AppLink_setStdin(void *(*func) (void))
{
    al_stdin = func;
}

__declspec(dllexport) void __cdecl AppLink_setStdout(void *(*func) (void))
{
    al_stdout = func;
}

__declspec(dllexport) void __cdecl AppLink_setStderr(void *(*func) (void))
{
    al_stderr = func;
}

__declspec(dllexport) void __cdecl AppLink_setFeof(int (*func) (FILE *fp))
{
    al_feof = func;
}

__declspec(dllexport) void __cdecl AppLink_setFerror(int (*func) (FILE *fp))
{
    al_ferror = func;
}

__declspec(dllexport) void __cdecl AppLink_setClearerr(int (*func) (FILE *fp))
{
    al_clearerr = func;
}

__declspec(dllexport) void __cdecl AppLink_setFileno(int (*func) (FILE *fp))
{
    al_fileno = func;
}

__declspec(dllexport) void __cdecl AppLink_setFsetmod(int (*func) (FILE *fp, char mod))
{
    al_fsetmod = func;
}

__declspec(dllexport) void **__cdecl AppLink_getALArray(void)
{
    static int once = 1;
    static void *OPENSSL_ApplinkTable[APPLINK_MAX + 1] =
        { (void *)APPLINK_MAX };

    if (once) {
        OPENSSL_ApplinkTable[APPLINK_STDIN] = app_stdin;
        OPENSSL_ApplinkTable[APPLINK_STDOUT] = app_stdout;
        OPENSSL_ApplinkTable[APPLINK_STDERR] = app_stderr;
        OPENSSL_ApplinkTable[APPLINK_FPRINTF] = fprintf;
        OPENSSL_ApplinkTable[APPLINK_FGETS] = fgets;
        OPENSSL_ApplinkTable[APPLINK_FREAD] = fread;
        OPENSSL_ApplinkTable[APPLINK_FWRITE] = fwrite;
        OPENSSL_ApplinkTable[APPLINK_FSETMOD] = app_fsetmod;
        OPENSSL_ApplinkTable[APPLINK_FEOF] = app_feof;
        OPENSSL_ApplinkTable[APPLINK_FCLOSE] = fclose;

        OPENSSL_ApplinkTable[APPLINK_FOPEN] = fopen;
        OPENSSL_ApplinkTable[APPLINK_FSEEK] = fseek;
        OPENSSL_ApplinkTable[APPLINK_FTELL] = ftell;
        OPENSSL_ApplinkTable[APPLINK_FFLUSH] = fflush;
        OPENSSL_ApplinkTable[APPLINK_FERROR] = app_ferror;
        OPENSSL_ApplinkTable[APPLINK_CLEARERR] = app_clearerr;
        OPENSSL_ApplinkTable[APPLINK_FILENO] = app_fileno;

        OPENSSL_ApplinkTable[APPLINK_OPEN] = _open;
        OPENSSL_ApplinkTable[APPLINK_READ] = _read;
        OPENSSL_ApplinkTable[APPLINK_WRITE] = _write;
        OPENSSL_ApplinkTable[APPLINK_LSEEK] = _lseek;
        OPENSSL_ApplinkTable[APPLINK_CLOSE] = _close;

        once = 0;
    }

    return OPENSSL_ApplinkTable;
}

#ifdef __cplusplus
}
#endif
