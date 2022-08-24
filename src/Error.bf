/*
* Generated by util/mkerr.pl DO NOT EDIT
* Copyright 1995-2019 The OpenSSL Project Authors. All Rights Reserved.
*
* Licensed under the OpenSSL license (the "License").  You may not use
* this file except in compliance with the License.  You can obtain a copy
* in the file LICENSE in the source distribution or at
* https://www.openssl.org/source/license.html
*/
using System;

namespace Beef_OpenSSL
{
	sealed static class Error
	{
#if !OPENSSL_NO_ERR
		[Inline]
		public static void PUT_error(int a, int b, int c, char8* d, int e) => put_error(a, b, c, d, e);
#else
		[Inline]
		public static void PUT_error(int a, int b, int c, char8* d, int e) => put_error(a, b, c, null, 0);
#endif
		
		public const int TXT_MALLOCED = 0x01;
		public const int TXT_STRING   = 0x02;
		
		public const int FLAG_MARK    = 0x01;
		public const int FLAG_CLEAR   = 0x02;
		
		public const int NUM_ERRORS   = 16;

		[CRepr]
		public struct state_st
		{
		    public int[NUM_ERRORS] err_flags;
		    public uint[NUM_ERRORS] err_buffer;
		    public char8*[NUM_ERRORS] err_data;
		    public int[NUM_ERRORS] err_data_flags;
		    public char8*[NUM_ERRORS] err_file;
		    public int[NUM_ERRORS] err_line;
		    public int top;
			public int bottom;
		}
		public typealias STATE = state_st;
		
		/* library */
		public const int LIB_NONE       = 1;
		public const int LIB_SYS        = 2;
		public const int LIB_BN         = 3;
		public const int LIB_RSA        = 4;
		public const int LIB_DH         = 5;
		public const int LIB_EVP        = 6;
		public const int LIB_BUF        = 7;
		public const int LIB_OBJ        = 8;
		public const int LIB_PEM        = 9;
		public const int LIB_DSA        = 10;
		public const int LIB_X509       = 11;
		/* public const int LIB_METH       = 12; */
		public const int LIB_ASN1       = 13;
		public const int LIB_CONF       = 14;
		public const int LIB_CRYPTO     = 15;
		public const int LIB_EC         = 16;
		public const int LIB_SSL        = 20;
		/* public const int LIB_SSL23      = 21; */
		/* public const int LIB_SSL2       = 22; */
		/* public const int LIB_SSL3       = 23; */
		/* public const int LIB_RSAREF     = 30; */
		/* public const int LIB_PROXY      = 31; */
		public const int LIB_BIO        = 32;
		public const int LIB_PKCS7      = 33;
		public const int LIB_X509V3     = 34;
		public const int LIB_PKCS12     = 35;
		public const int LIB_RAND       = 36;
		public const int LIB_DSO        = 37;
		public const int LIB_ENGINE     = 38;
		public const int LIB_OCSP       = 39;
		public const int LIB_UI         = 40;
		public const int LIB_COMP       = 41;
		public const int LIB_ECDSA      = 42;
		public const int LIB_ECDH       = 43;
		public const int LIB_OSSL_STORE = 44;
		public const int LIB_FIPS       = 45;
		public const int LIB_CMS        = 46;
		public const int LIB_TS         = 47;
		public const int LIB_HMAC       = 48;
		/* public const int LIB_JPAKE      = 49; */
		public const int LIB_CT         = 50;
		public const int LIB_ASYNC      = 51;
		public const int LIB_KDF        = 52;
		public const int LIB_SM2        = 53;
		
		public const int LIB_USER       = 128;
		
		[Inline]
		public static void SYSerr(int f, int r) => PUT_error(LIB_SYS, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void BNerr(int f, int r) => PUT_error(LIB_BN, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void RSAerr(int f, int r) => PUT_error(LIB_RSA, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void DHerr(int f, int r) => PUT_error(LIB_DH, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void EVPerr(int f, int r) => PUT_error(LIB_EVP, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void BUFerr(int f, int r) => PUT_error(LIB_BUF, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void OBJerr(int f, int r) => PUT_error(LIB_OBJ, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void PEMerr(int f, int r) => PUT_error(LIB_PEM, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void DSAerr(int f, int r) => PUT_error(LIB_DSA, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void X509err(int f, int r) => PUT_error(LIB_X509, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void ASN1err(int f, int r) => PUT_error(LIB_ASN1, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void CONFerr(int f, int r) => PUT_error(LIB_CONF, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void CRYPTOerr(int f, int r) => PUT_error(LIB_CRYPTO, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void ECerr(int f, int r) => PUT_error(LIB_EC, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void SSLerr(int f, int r) => PUT_error(LIB_SSL, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void BIOerr(int f, int r) => PUT_error(LIB_BIO, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void PKCS7err(int f, int r) => PUT_error(LIB_PKCS7, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void X509V3err(int f, int r) => PUT_error(LIB_X509V3, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void PKCS12err(int f, int r) => PUT_error(LIB_PKCS12, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void RANDerr(int f, int r) => PUT_error(LIB_RAND, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void DSOerr(int f, int r) => PUT_error(LIB_DSO, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void ENGINEerr(int f, int r) => PUT_error(LIB_ENGINE, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void OCSPerr(int f, int r) => PUT_error(LIB_OCSP, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void UIerr(int f, int r) => PUT_error(LIB_UI, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void COMPerr(int f, int r) => PUT_error(LIB_COMP, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void ECDSAerr(int f, int r) => PUT_error(LIB_ECDSA, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void ECDHerr(int f, int r) => PUT_error(LIB_ECDH, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void OSSL_STOREerr(int f, int r) => PUT_error(LIB_OSSL_STORE, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void FIPSerr(int f, int r) => PUT_error(LIB_FIPS, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void CMSerr(int f, int r) => PUT_error(LIB_CMS, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void TSerr(int f, int r) => PUT_error(LIB_TS, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void HMACerr(int f, int r) => PUT_error(LIB_HMAC, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void CTerr(int f, int r) => PUT_error(LIB_CT, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void ASYNCerr(int f, int r) => PUT_error(LIB_ASYNC, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void KDFerr(int f, int r) => PUT_error(LIB_KDF, f, r, OpenSSL.FILE, OpenSSL.LINE);
		[Inline]
		public static void SM2err(int f, int r) => PUT_error(LIB_SM2, f, r, OpenSSL.FILE, OpenSSL.LINE);
		
		[Inline]
		public static uint PACK(uint l, uint f, uint r) => ((l & 0x0FF) << 24L) | ((f & 0xFFF) << 12L) | (r & 0xFFF);
		[Inline]
		public static int GET_LIB(int l) => (l >> 24L) & 0x0FFL;
		[Inline]
		public static int GET_FUNC(int l) => (l >> 12L) & 0xFFFL;
		[Inline]
		public static int GET_REASON(int l) => l & 0xFFFL;
		[Inline]
		public static int FATAL_ERROR(int l) => l & R_FATAL;
		
		/* OS functions */
		public const int SYS_F_FOPEN         = 1;
		public const int SYS_F_CONNECT       = 2;
		public const int SYS_F_GETSERVBYNAME = 3;
		public const int SYS_F_SOCKET        = 4;
		public const int SYS_F_IOCTLSOCKET   = 5;
		public const int SYS_F_BIND          = 6;
		public const int SYS_F_LISTEN        = 7;
		public const int SYS_F_ACCEPT        = 8;
		public const int SYS_F_WSASTARTUP    = 9;  /* Winsock stuff */
		public const int SYS_F_OPENDIR       = 10;
		public const int SYS_F_FREAD         = 11;
		public const int SYS_F_GETADDRINFO   = 12;
		public const int SYS_F_GETNAMEINFO   = 13;
		public const int SYS_F_SETSOCKOPT    = 14;
		public const int SYS_F_GETSOCKOPT    = 15;
		public const int SYS_F_GETSOCKNAME   = 16;
		public const int SYS_F_GETHOSTBYNAME = 17;
		public const int SYS_F_FFLUSH        = 18;
		public const int SYS_F_OPEN          = 19;
		public const int SYS_F_CLOSE         = 20;
		public const int SYS_F_IOCTL         = 21;
		public const int SYS_F_STAT          = 22;
		public const int SYS_F_FCNTL         = 23;
		public const int SYS_F_FSTAT         = 24;
		
		/* reasons */
		public const int R_SYS_LIB        = LIB_SYS;        /* 2 */
		public const int R_BN_LIB         = LIB_BN;         /* 3 */
		public const int R_RSA_LIB        = LIB_RSA;        /* 4 */
		public const int R_DH_LIB         = LIB_DH;         /* 5 */
		public const int R_EVP_LIB        = LIB_EVP;        /* 6 */
		public const int R_BUF_LIB        = LIB_BUF;        /* 7 */
		public const int R_OBJ_LIB        = LIB_OBJ;        /* 8 */
		public const int R_PEM_LIB        = LIB_PEM;        /* 9 */
		public const int R_DSA_LIB        = LIB_DSA;        /* 10 */
		public const int R_X509_LIB       = LIB_X509;       /* 11 */
		public const int R_ASN1_LIB       = LIB_ASN1;       /* 13 */
		public const int R_EC_LIB         = LIB_EC;         /* 16 */
		public const int R_BIO_LIB        = LIB_BIO;        /* 32 */
		public const int R_PKCS7_LIB      = LIB_PKCS7;      /* 33 */
		public const int R_X509V3_LIB     = LIB_X509V3;     /* 34 */
		public const int R_ENGINE_LIB     = LIB_ENGINE;     /* 38 */
		public const int R_UI_LIB         = LIB_UI;         /* 40 */
		public const int R_ECDSA_LIB      = LIB_ECDSA;      /* 42 */
		public const int R_OSSL_STORE_LIB = LIB_OSSL_STORE; /* 44 */
		
		public const int R_NESTED_ASN1_ERROR           = 58;
		public const int R_MISSING_ASN1_EOS            = 63;
		
		/* fatal error */
		public const int R_FATAL                       = 64;
		public const int R_MALLOC_FAILURE              = 1 | R_FATAL;
		public const int R_SHOULD_NOT_HAVE_BEEN_CALLED = 2 | R_FATAL;
		public const int R_PASSED_NULL_PARAMETER       = 3 | R_FATAL;
		public const int R_INTERNAL_ERROR              = 4 | R_FATAL;
		public const int R_DISABLED                    = 5 | R_FATAL;
		public const int R_INIT_FAIL                   = 6 | R_FATAL;
		public const int R_PASSED_INVALID_ARGUMENT     = 7;
		public const int R_OPERATION_FAIL              = 8 | R_FATAL;
		
		/* 99 is the maximum possible R_... code, higher values are reserved for the individual libraries */
		[CRepr]
		public struct string_data_st
		{
		    public uint error;
		    public char8* string;
		}
		public typealias STRING_DATA = string_data_st;
		
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_put_error")
		]
		public extern static void put_error(int lib, int func, int reason, char8* file, int line);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_set_error_data")
		]
		public extern static void set_error_data(char8* data, int flags);
		
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_get_error")
		]
		public extern static uint get_error();
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_get_error_line")
		]
		public extern static uint get_error_line(char8** file, int* line);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_get_error_line_data")
		]
		public extern static uint get_error_line_data(char8** file, int* line, char8** data, int* flags);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_peek_error")
		]
		public extern static uint peek_error();
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_peek_error_line")
		]
		public extern static uint peek_error_line(char8** file, int* line);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_peek_error_line_data")
		]
		public extern static uint peek_error_line_data(char8** file, int* line, char8** data, int* flags);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_peek_last_error")
		]
		public extern static uint peek_last_error();
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_peek_last_error_line")
		]
		public extern static uint peek_last_error_line(char8** file, int* line);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_peek_last_error_line_data")
		]
		public extern static uint peek_last_error_line_data(char8** file, int* line,  char8** data, int* flags);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_clear_error")
		]
		public extern static void clear_error();
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_error_string")
		]
		public extern static char8* error_string(uint e, char8* buf);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_error_string_n")
		]
		public extern static void error_string_n(uint e, char8* buf, uint len);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_lib_error_string")
		]
		public extern static char8* lib_error_string(uint e);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_func_error_string")
		]
		public extern static char8* func_error_string(uint e);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_reason_error_string")
		]
		public extern static char8* reason_error_string(uint e);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_print_errors_cb")
		]
		public extern static void print_errors_cb(function int(char8* str, uint len, void* u) cb, void* u);
#if !OPENSSL_NO_STDIO
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_print_errors_fp")
		]
		public extern static void print_errors_fp(Platform.BfpFile* fp);
#endif
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_print_errors")
		]
		public extern static void print_errors(BIO.bio_st* bp);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_add_error_data")
		]
		public extern static void add_error_data(int num, ...);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_add_error_vdata")
		]
		public extern static void add_error_vdata(int num, void* args);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_load_strings")
		]
		public extern static int load_strings(int lib, STRING_DATA* str);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_load_strings_const")
		]
		public extern static int load_strings_const(STRING_DATA* str);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_unload_strings")
		]
		public extern static int unload_strings(int lib, STRING_DATA* str);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_load_ERR_strings")
		]
		public extern static int load_ERR_strings();
		
		[Inline]
		public static int load_crypto_strings() => OpenSSL.init_crypto(OpenSSL.INIT_LOAD_CRYPTO_STRINGS, null);
		[Inline, Obsolete("No longer needed, so this is a no-op", true)]
		public static void free_strings() { while(false) continue; }
		
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_remove_thread_state")
		]
		public extern static void remove_thread_state(void* p);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_remove_state")
		]
		public extern static void remove_state(uint pid);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_get_state")
		]
		public extern static STATE* get_state();
		
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_get_next_error_library")
		]
		public extern static int get_next_error_library();
		
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_set_mark")
		]
		public extern static int set_mark();
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_pop_to_mark")
		]
		public extern static int pop_to_mark();
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("ERR_clear_last_mark")
		]
		public extern static int clear_last_mark();
	}
}
