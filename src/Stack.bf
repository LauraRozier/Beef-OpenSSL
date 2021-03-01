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
	sealed abstract class Stack
	{
		[CRepr]
		public struct stack_st
		{
		    public int num;
		    public void** data;
		    public int sorted;
		    public int num_alloc;
		    public OpenSSL.sk_compfunc comp;
		}
		public typealias OPENSSL_STACK = stack_st; /* Use STACK_OF(...) instead */
	}
}