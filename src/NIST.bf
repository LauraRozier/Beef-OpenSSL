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
	sealed abstract class NISTP224
	{
		public typealias limb = uint64;
		public typealias felem = limb[4];

		/* The un-portables
		[Align(1)]
		public typealias limb_aX = uint64; // We are unable to align a typealias
		public typealias widelimb = uint128;
		public typealias widefelem = widelimb[7];
		*/
		
		/* Precomputation for the group generator. */
		[CRepr]
		public struct pre_comp_st
		{
		    public felem[2][16][3] g_pre_comp;
		    public Crypto.REF_COUNT references;
		    public Crypto.RWLOCK* lock;
		}
		public typealias PRE_COMP = pre_comp_st;
	}

	sealed abstract class NISTP256
	{
		private const int NLIMBS = 4;
		public typealias smallfelem = uint64[4 /* NLIMBS */];
		
		/* The un-portables
		public typealias limb = uint128;
		public typealias felem = limb[4 /* NLIMBS */];
		public typealias longfelem = limb[4 /* NLIMBS */ * 2];
		*/

		/* Precomputation for the group generator. */
		[CRepr]
		public struct pre_comp_st
		{
		    public smallfelem[2][16][3] g_pre_comp;
		    public Crypto.REF_COUNT references;
		    public Crypto.RWLOCK* lock;
		}
		public typealias PRE_COMP = pre_comp_st;
	}

	sealed abstract class NISTP521
	{
		private const int NLIMBS = 9;
		public typealias limb = uint64;
		public typealias felem = limb[9 /* NLIMBS */];

		/* The un-portables
		[Align(1)]
		public typealias limb_aX = limb; // We are unable to align a typealias
		public typealias largefelem = uint128[NLIMBS];
		*/

		/* Precomputation for the group generator. */
		[CRepr]
		public struct pre_comp_st
		{
		    public felem[16][3] g_pre_comp;
		    public Crypto.REF_COUNT references;
		    public Crypto.RWLOCK* lock;
		}
		public typealias PRE_COMP = pre_comp_st;
	}

	sealed abstract class NISTZ256
	{
		/* structure for precomputed multiples of the generator */
		[CRepr]
		public struct pre_comp_st
		{
		    public EC.GROUP* group;             /* Parent EC_GROUP object */
		    public uint w;                      /* Window size */
		    /* Constant time access to the X and Y coordinates of the pre-computed, generator multiplies, in the Montgomery domain. Pre-calculated multiplies are stored in affine form. */
		    public void* precomp;               /* PRECOMP256_ROW */ 
		    public void* precomp_storage;
		    public Crypto.REF_COUNT references;
		    public Crypto.RWLOCK* lock;
		}
		public typealias PRE_COMP = pre_comp_st;
	}
}