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
	sealed abstract class DSA
	{
#if !OPENSSL_NO_DSA
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			CLink
		]
		public extern static int ERR_load_DSA_strings();
		
		/*
		 * DSA function codes.
		 */
		public const int F_DSAPARAMS_PRINT          = 100;
		public const int F_DSAPARAMS_PRINT_FP       = 101;
		public const int F_DSA_BUILTIN_PARAMGEN     = 125;
		public const int F_DSA_BUILTIN_PARAMGEN2    = 126;
		public const int F_DSA_DO_SIGN              = 112;
		public const int F_DSA_DO_VERIFY            = 113;
		public const int F_DSA_METH_DUP             = 127;
		public const int F_DSA_METH_NEW             = 128;
		public const int F_DSA_METH_SET1_NAME       = 129;
		public const int F_DSA_NEW_METHOD           = 103;
		public const int F_DSA_PARAM_DECODE         = 119;
		public const int F_DSA_PRINT_FP             = 105;
		public const int F_DSA_PRIV_DECODE          = 115;
		public const int F_DSA_PRIV_ENCODE          = 116;
		public const int F_DSA_PUB_DECODE           = 117;
		public const int F_DSA_PUB_ENCODE           = 118;
		public const int F_DSA_SIGN                 = 106;
		public const int F_DSA_SIGN_SETUP           = 107;
		public const int F_DSA_SIG_NEW              = 102;
		public const int F_OLD_DSA_PRIV_DECODE      = 122;
		public const int F_PKEY_DSA_CTRL            = 120;
		public const int F_PKEY_DSA_CTRL_STR        = 104;
		public const int F_PKEY_DSA_KEYGEN          = 121;
		
		/*
		 * DSA reason codes.
		 */
		public const int R_BAD_Q_VALUE              = 102;
		public const int R_BN_DECODE_ERROR          = 108;
		public const int R_BN_ERROR                 = 109;
		public const int R_DECODE_ERROR             = 104;
		public const int R_INVALID_DIGEST_TYPE      = 106;
		public const int R_INVALID_PARAMETERS       = 112;
		public const int R_MISSING_PARAMETERS       = 101;
		public const int R_MISSING_PRIVATE_KEY      = 111;
		public const int R_MODULUS_TOO_LARGE        = 103;
		public const int R_NO_PARAMETERS_SET        = 107;
		public const int R_PARAMETER_ENCODING_ERROR = 105;
		public const int R_Q_NOT_PRIME              = 113;
		public const int R_SEED_LEN_SMALL           = 110;

		public const int FLAG_CACHE_MONT_P      = 0x01;
		/* Does nothing. Previously this switched off constant time behaviour. */
		public const int FLAG_NO_EXP_CONSTTIME = 0x00;
		/*
		 * If this flag is set the DSA method is FIPS compliant and can be used in FIPS mode. This is set in the validated module method. If an application sets this flag in its own methods it is its responsibility to ensure the
		 * result is compliant.
		 */
		public const int FLAG_FIPS_METHOD       = 0x0400;
		/* If this flag is set the operations normally disabled in FIPS mode are permitted it is then the applications responsibility to ensure that the usage is compliant. */
		public const int FLAG_NON_FIPS_ALLOW    = 0x0400;
		public const int FLAG_FIPS_CHECKED      = 0x0800;

		/* Already defined in ossl_typ.h */
		/* typedef struct dsa_st DSA; */
		/* typedef struct dsa_method DSA_METHOD; */
		[CRepr]
		public struct SIG_st
		{
		    public BN.BIGNUM* r;
		    public BN.BIGNUM* s;
		}
		public typealias SIG = SIG_st;

		[CRepr]
		public struct dsa_st
		{
		    /* This first variable is used to pick up errors where a DSA is passed instead of of a EVP.PKEY */
		    public int pad;
		    public int32 version;
		    public BN.BIGNUM* p;
		    public BN.BIGNUM* q;                /* == 20 */
		    public BN.BIGNUM* g;
		    public BN.BIGNUM* pub_key;          /* y public key */
		    public BN.BIGNUM* priv_key;         /* x private key */
		    public int flags;
		    /* Normally used to cache montgomery values */
		    public BN.MONT_CTX* method_mont_p;
		    public Crypto.REF_COUNT references;
		    public Crypto.EX_DATA ex_data;
		    public METHOD* meth;
		    /* functional reference if 'meth' is ENGINE-provided */
		    public Engine.ENGINE* engine;
		    public Crypto.RWLOCK* lock;
		}
		public typealias DSA = dsa_st;
		
		[CRepr]
		public struct method_st
		{
		    public char8* name;
		    public function SIG*(uint8* dgst, int dlen, dsa_st* dsa) dsa_do_sign;
		    public function int(dsa_st* dsa, BN.CTX* ctx_in, BN.BIGNUM** kinvp, BN.BIGNUM** rp) dsa_sign_setup;
		    public function int(uint8* dgst, int dgst_len, SIG* sig, dsa_st* dsa) dsa_do_verify;
		    public function int(dsa_st* dsa, BN.BIGNUM* rr, BN.BIGNUM* a1, BN.BIGNUM* p1, BN.BIGNUM* a2, BN.BIGNUM* p2, BN.BIGNUM* m, BN.CTX* ctx, BN.MONT_CTX* in_mont) dsa_mod_exp;
		    /* Can be null */
		    public function int(dsa_st* dsa, BN.BIGNUM* r, BN.BIGNUM* a, BN.BIGNUM* p, BN.BIGNUM* m, BN.CTX* ctx, BN.MONT_CTX* m_ctx) bn_mod_exp;
		    public function int(dsa_st* dsa) init;
		    public function int(dsa_st* dsa) finish;
		    public int flags;
		    public void* app_data;
		    /* If this is non-NULL, it is used to generate DSA parameters */
		    public function int(dsa_st* dsa, int bits, uint8* seed, int seed_len, int* counter_ret, uint* h_ret, BN.GENCB* cb) dsa_paramgen;
		    /* If this is non-NULL, it is used to generate DSA keys */
		    public function int(dsa_st* dsa) dsa_keygen;
		}
		public typealias METHOD = method_st;

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_SIG_new")
		]
		public extern static SIG* SIG_new();
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_SIG_free")
		]
		public extern static void SIG_free(SIG* sig);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			CLink
		]
		public extern static int i2d_DSA_SIG(SIG* a, uint8** pp);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			CLink
		]
		public extern static SIG* d2i_DSA_SIG(SIG** v, uint8** pp, int length);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_SIG_get0")
		]
		public extern static void SIG_get0(SIG* sig, BN.BIGNUM** pr, BN.BIGNUM** ps);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_SIG_set0")
		]
		public extern static int SIG_set0(SIG* sig, BN.BIGNUM* r, BN.BIGNUM* s);

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_do_sign")
		]
		public extern static SIG* do_sign(uint8* dgst, int dlen, dsa_st* dsa);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_do_verify")
		]
		public extern static int do_verify(uint8* dgst, int dgst_len, SIG* sig, dsa_st* dsa);

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_OpenSSL")
		]
		public extern static METHOD* OpenSSL();

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_set_default_method")
		]
		public extern static void set_default_method(METHOD* a);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get_default_method")
		]
		public extern static METHOD* get_default_method();
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_set_method")
		]
		public extern static int set_method(dsa_st* dsa, METHOD* a);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get_method")
		]
		public extern static METHOD* get_method(dsa_st* d);

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_new")
		]
		public extern static dsa_st* new_();
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_new_method")
		]
		public extern static dsa_st* new_method(Engine.ENGINE* engine);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_free")
		]
		public extern static void free(dsa_st* r);
		/* "up" the DSA object's reference count */
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_up_ref")
		]
		public extern static int up_ref(dsa_st* r);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_size")
		]
		public extern static int size(dsa_st* s);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_bits")
		]
		public extern static int bits(dsa_st* d);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_security_bits")
		]
		public extern static int security_bits(dsa_st* d);
		/* next 4 return -1 on error */
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_sign_setup")
		]
		public extern static int sign_setup(dsa_st* dsa, BN.CTX* ctx_in, BN.BIGNUM** kinvp, BN.BIGNUM** rp);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_sign")
		]
		public extern static int sign(int type, uint8* dgst, int dlen, uint8* sig, uint* siglen, dsa_st* dsa);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_verify")
		]
		public extern static int verify(int type, uint8* dgst, int dgst_len, uint8* sigbuf, int siglen, dsa_st* dsa);
		[Inline]
		public static int get_ex_new_index(int l, void* p, Crypto.EX_new newf, Crypto.EX_dup dupf, Crypto.EX_free freef) => Crypto.get_ex_new_index(Crypto.EX_INDEX_DSA, l, p, newf, dupf, freef);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_set_ex_data")
		]
		public extern static int set_ex_data(dsa_st* d, int idx, void* arg);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get_ex_data")
		]
		public extern static void* get_ex_data(dsa_st* d, int idx);

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			CLink
		]
		public extern static dsa_st* d2i_DSAPublicKey(dsa_st** a, uint8** pp, int length);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			CLink
		]
		public extern static dsa_st* d2i_DSAPrivateKey(dsa_st** a, uint8** pp, int length);

		/* Deprecated version */
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_generate_parameters")
		]
		public extern static dsa_st* generate_parameters(int bits, uint8* seed, int seed_len, int* counter_ret, uint* h_ret, function void(int, int, void*) callback, void* cb_arg);

		/* New version */
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_generate_parameters_ex")
		]
		public extern static int generate_parameters_ex(dsa_st* dsa, int bits, uint8* seed, int seed_len, int* counter_ret, uint* h_ret, BN.GENCB* cb);

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_generate_key")
		]
		public extern static int generate_key(dsa_st* a);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			CLink
		]
		public extern static int i2d_DSAPublicKey(dsa_st* a, uint8** pp);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			CLink
		]
		public extern static int i2d_DSAPrivateKey(dsa_st* a, uint8** pp);
		
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_print")
		]
		public extern static int print(BIO.bio_st* bp, dsa_st* x, int off);
	#if !OPENSSL_NO_STDIO
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_print_fp")
		]
		public extern static int print_fp(Platform.BfpFile* bp, dsa_st* x, int off);
	#endif

		public const int DSS_prime_checks = 64;
		/*
		 * Primality test according to FIPS PUB 186-4, Appendix C.3. Since we only have one value here we set the number of checks to 64 which is the 128 bit
		 * security level that is the highest level and valid for creating a 3072 bit DSA key.
		 */
		[Inline]
		public static int is_prime(BN.BIGNUM* n, function void(int, int, void*) callback, void* cb_arg) => BN.is_prime(n, DSS_prime_checks, callback, null, cb_arg);

	#if !OPENSSL_NO_DH
		/* Convert DSA structure (key or just parameters) into DH structure (be careful to avoid small subgroup attacks when using this!) */
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_dup_DH")
		]
		public extern static DH.dh_st* dup_DH(dsa_st* r);
	#endif

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get0_pqg")
		]
		public extern static void get0_pqg(dsa_st* d, BN.BIGNUM** p, BN.BIGNUM** q, BN.BIGNUM** g);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_set0_pqg")
		]
		public extern static int set0_pqg(dsa_st* d, BN.BIGNUM* p, BN.BIGNUM* q, BN.BIGNUM* g);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get0_key")
		]
		public extern static void get0_key(dsa_st* d, BN.BIGNUM** pub_key, BN.BIGNUM** priv_key);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_set0_key")
		]
		public extern static int set0_key(dsa_st* d, BN.BIGNUM* pub_key, BN.BIGNUM* priv_key);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get0_p")
		]
		public extern static BN.BIGNUM* get0_p(dsa_st* d);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get0_q")
		]
		public extern static BN.BIGNUM* get0_q(dsa_st* d);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get0_g")
		]
		public extern static BN.BIGNUM* get0_g(dsa_st* d);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get0_pub_key")
		]
		public extern static BN.BIGNUM* get0_pub_key(dsa_st* d);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get0_priv_key")
		]
		public extern static BN.BIGNUM* get0_priv_key(dsa_st* d);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_clear_flags")
		]
		public extern static void clear_flags(dsa_st* d, int flags);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_test_flags")
		]
		public extern static int test_flags(dsa_st* d, int flags);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_set_flags")
		]
		public extern static void set_flags(dsa_st* d, int flags);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_get0_engine")
		]
		public extern static Engine.ENGINE* get0_engine(dsa_st* d);

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_new")
		]
		public extern static METHOD* meth_new(char8* name, int flags);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_free")
		]
		public extern static void meth_free(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_dup")
		]
		public extern static METHOD* meth_dup(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get0_name")
		]
		public extern static char8* meth_get0_name(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set1_name")
		]
		public extern static int meth_set1_name(METHOD* dsam, char8* name);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_flags")
		]
		public extern static int meth_get_flags(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_flags")
		]
		public extern static int meth_set_flags(METHOD* dsam, int flags);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get0_app_data")
		]
		public extern static void* meth_get0_app_data(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set0_app_data")
		]
		public extern static int meth_set0_app_data(METHOD* dsam, void* app_data);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_sign")
		]
		public extern static function SIG*(uint8*, int, dsa_st*) meth_get_sign(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_sign")
		]
		public extern static int meth_set_sign(METHOD* dsam, function SIG* (uint8*, int, dsa_st*) sign);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_sign_setup")
		]
		public extern static function int(dsa_st*, BN.CTX*, BN.BIGNUM**, BN.BIGNUM**) meth_get_sign_setup(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_sign_setup")
		]
		public extern static int meth_set_sign_setup(METHOD* dsam, function int(dsa_st*, BN.CTX*, BN.BIGNUM**, BN.BIGNUM**) sign_setup);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_verify")
		]
		public extern static function int(uint8*, int, SIG*, dsa_st*) meth_get_verify(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_verify")
		]
		public extern static int meth_set_verify(METHOD* dsam, function int(uint8*, int, SIG*, dsa_st*) verify);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_mod_exp")
		]
		public extern static function int(dsa_st*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.CTX*, BN.MONT_CTX*) meth_get_mod_exp(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_mod_exp")
		]
		public extern static int meth_set_mod_exp(METHOD* dsam, function int(dsa_st*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.CTX*, BN.MONT_CTX*) mod_exp);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_bn_mod_exp")
		]
		public extern static function int(dsa_st*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.CTX*, BN.MONT_CTX*) meth_get_bn_mod_exp(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_bn_mod_exp")
		]
		public extern static int meth_set_bn_mod_exp(METHOD* dsam, function int(dsa_st*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.BIGNUM*, BN.CTX*, BN.MONT_CTX*) bn_mod_exp);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_init")
		]
		public extern static function int(dsa_st*) meth_get_init(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_init")
		]
		public extern static int meth_set_init(METHOD* dsam, function int(dsa_st*) init);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_finish")
		]
		public extern static function int(dsa_st*) meth_get_finish(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_finish")
		]
		public extern static int meth_set_finish(METHOD* dsam, function int(dsa_st*) finish);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_paramgen")
		]
		public extern static function int(dsa_st*, int, uint8*, int, int*, uint*, BN.GENCB*) meth_get_paramgen(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_paramgen")
		]
		public extern static int meth_set_paramgen(METHOD* dsam, function int(dsa_st*, int, uint8*, int, int*, uint*, BN.GENCB*) paramgen);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_get_keygen")
		]
		public extern static function int(dsa_st*) meth_get_keygen(METHOD* dsam);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSA_meth_set_keygen")
		]
		public extern static int meth_set_keygen(METHOD* dsam, function int(dsa_st*) keygen);
#endif
	}

	sealed abstract class DSAparams
	{
#if !OPENSSL_NO_DSA
		[Inline]
		public static DSA.dsa_st* d2i_DHparams_fp(Platform.BfpFile* fp, DSA.dsa_st** x)
		{
			void* innerF1() => (void*)DSA.new_();
			void* innerF2(void** p, uint8** n, int l) => (void*)d2i_DSAparams((DSA.dsa_st**)p, n, l);
			return (DSA.dsa_st*)ASN1.d2i_fp(=> innerF1, => innerF2, fp, (void**)x);
		}
		[Inline]
		public static int i2d_DHparams_fp(Platform.BfpFile* fp, DSA.dsa_st* x)
		{
			int innerF(void* p, uint8** n) => i2d_DSAparams((DSA.dsa_st*)p, n);
			return ASN1.i2d_fp(=> innerF, fp, (uint8*)x);
		}
		[Inline]
		public static DSA.dsa_st* d2i_DHparams_bio(BIO.bio_st* bp, DSA.dsa_st** x)
		{
			void* innerF1() => (void*)DSA.new_();
			void* innerF2(void** p, uint8** n, int l) => (void*)d2i_DSAparams((DSA.dsa_st**)p, n, l);
			return (DSA.dsa_st*)ASN1.d2i_bio(=> innerF1, => innerF2, bp, (void**)x);
		}
		[Inline]
		public static int i2d_DSAparams_bio(BIO.bio_st* bp, DSA.dsa_st* x)
		{
			int innerFunc(void* p, uint8** n) => i2d_DSAparams((DSA.dsa_st*)p, n);
			return ASN1.i2d_bio(=> innerFunc, bp, (uint8*)x);
		}

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSAparams_dup")
		]
		public extern static DSA.dsa_st* dup(DSA.dsa_st* x);

		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			CLink
		]
		public extern static DSA.dsa_st* d2i_DSAparams(DSA.dsa_st** a, uint8** pp, int length);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			CLink
		]
		public extern static int i2d_DSAparams(DSA.dsa_st* a, uint8** pp);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSAparams_print")
		]
		public extern static int print(BIO.bio_st* bp, DSA.dsa_st* x);
	#if !OPENSSL_NO_STDIO
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("DSAparams_print_fp")
		]
		public extern static int print_fp(Platform.BfpFile* fp, DSA.dsa_st* x);
	#endif
#endif
	}
}