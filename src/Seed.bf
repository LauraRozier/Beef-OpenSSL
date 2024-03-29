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
	sealed static class Seed
	{
#if !OPENSSL_NO_SEED
	/* look whether we need 'long' to get 32 bits */
	#if AES_LONG && !SEED_LONG
		#define SEED_LONG
	#endif

		public const int BLOCK_SIZE = 16;
		public const int KEY_LENGTH = 16;
		
		public struct key_st
		{
	#if SEED_LONG
		    uint32[32] data;
	#else
		    uint[32] data;
	# endif
		}
		public typealias KEY_SCHEDULE = key_st;
		
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("SEED_set_key")
		]
		public extern static void set_key(uint8[KEY_LENGTH] rawkey, KEY_SCHEDULE* ks);
		
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("SEED_encrypt")
		]
		public extern static void encrypt(uint8[BLOCK_SIZE] s, uint8[BLOCK_SIZE] d, KEY_SCHEDULE* ks);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("SEED_decrypt")
		]
		public extern static void decrypt(uint8[BLOCK_SIZE] s, uint8[BLOCK_SIZE] d, KEY_SCHEDULE* ks);
		
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("SEED_ecb_encrypt")
		]
		public extern static void ecb_encrypt(uint8* inVal, uint8* outVal, KEY_SCHEDULE* ks, int enc);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("SEED_cbc_encrypt")
		]
		public extern static void cbc_encrypt(uint8* inVal, uint8* outVal, uint len, KEY_SCHEDULE* ks, uint8[BLOCK_SIZE] ivec, int enc);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("SEED_cfb128_encrypt")
		]
		public extern static void cfb128_encrypt(uint8* inVal, uint8* outVal, uint len, KEY_SCHEDULE* ks, uint8[BLOCK_SIZE] ivec, int *num, int enc);
		[
#if !OPENSSL_LINK_STATIC
			Import(OPENSSL_LIB_CRYPTO),
#endif
			LinkName("SEED_ofb128_encrypt")
		]
		public extern static void ofb128_encrypt(uint8* inVal, uint8* outVal, uint len, KEY_SCHEDULE* ks, uint8[BLOCK_SIZE] ivec, int *num);
#endif
	}
}
