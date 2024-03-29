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
	sealed static class OSSL
	{
		/* Binary/behaviour compatibility levels */
		public const uint DYNAMIC_VERSION = 0x00030000U;
		/* Binary versions older than this are too old for us (whether we're a loader or a loadee) */
		public const uint DYNAMIC_OLDEST  = 0x00030000U;
	}

	sealed static class OSSLType
	{
		[CRepr]
		public struct tm
		{
		    public int tm_sec;   // seconds after the minute - [0, 60] including leap second
		    public int tm_min;   // minutes after the hour - [0, 59]
		    public int tm_hour;  // hours since midnight - [0, 23]
		    public int tm_mday;  // day of the month - [1, 31]
		    public int tm_mon;   // months since January - [0, 11]
		    public int tm_year;  // years since 1900
		    public int tm_wday;  // days since Sunday - [0, 6]
		    public int tm_yday;  // days since January 1 - [0, 365]
		    public int tm_isdst; // daylight savings time flag
		}

#if BF_PLATFORM_WINDOWS
		[CRepr]
		public struct hostent
		{
			public char8*  h_name;      /* The official name of the host (PC). */
			public char8** h_aliases;   /* A NULL-terminated array of alternate names. */
			public int16   h_addrtype;  /* The type of address being returned. */
			public int16   h_length;    /* The length, in bytes, of each address. */
			public char8** h_addr_list; /* A NULL-terminated list of addresses for the host. */
		}
		public typealias HOSTENT = hostent;
		public typealias PHOSTENT = hostent*;
		public typealias LPHOSTENT = hostent*;

		[CRepr]
		public struct sockaddr
		{
			public uint16    sa_family;
			public char8[14] sa_data;
		}
		typealias SOCKADDR = sockaddr;
		typealias PSOCKADDR = sockaddr*;
		typealias LPSOCKADDR = sockaddr*;
		
		[CRepr]
		public struct in_addr
		{
			public S_un_struct S_un;

			[CRepr, Union]
			public struct S_un_struct
			{
				public S_un_b_struct S_un_b; /* Address in bytes */
				public S_un_w_struct S_un_w; /* Address in words */
				public uint          S_addr; /* Address in uint */

				[CRepr]
				public struct S_un_b_struct
				{
					public uint8 s_b1;
					public uint8 s_b2;
					public uint8 s_b3;
					public uint8 s_b4;
				}

				[CRepr]
				public struct S_un_w_struct
				{
					public uint16 s_w1;
					public uint16 s_w2;
				}
			}
		}
		typealias IN_ADDR = in_addr;
		typealias PIN_ADDR = in_addr*;
		typealias LPIN_ADDR = in_addr*;

		[CRepr]
		public struct sockaddr_in
		{
			public int16    sin_family;
			public uint16   sin_port;
			public in_addr  sin_addr;
			public char8[8] sin_zero;
		}
		typealias SOCKADDR_IN = sockaddr_in;
		typealias PSOCKADDR_IN = sockaddr_in*;
		typealias LPSOCKADDR_IN = sockaddr_in*;
		
		[CRepr]
		public struct in6_addr
		{
			public u_struct u;

			[CRepr, Union]
			public struct u_struct
			{
			    public uint8[16] Byte;
			    public uint16[8] Word;
			}
		}
		typealias IN6_ADDR = in6_addr;
		typealias PIN6_ADDR = in6_addr*;
		typealias LPIN6_ADDR = in6_addr*;

		[CRepr]
		public struct sockaddr_in6
		{
			public int16    sin6_family;
			public uint16   sin6_port;
			public uint     sin6_flowinfo;
			public in6_addr sin6_addr;
			public uint     sin6_scope_id;
		}
		typealias SOCKADDR_IN6 = sockaddr_in6;
		typealias PSOCKADDR_IN6 = sockaddr_in6*;
		typealias LPSOCKADDR_IN6 = sockaddr_in6*;
#elif BF_PLATFORM_LINUX
		[CRepr]
		public struct hostent
		{
		     public char8*  h_name;      /* official name of host */
		     public char8** h_aliases;   /* alias list */
		     public int     h_addrtype;  /* host address type */
		     public int     h_length;    /* length of address */
		     public char8** h_addr_list; /* list of addresses */
		}

		typealias sa_family_t = uint16;
		typealias in_port_t = uint16;
		typealias in_addr_t = uint32;

		[CRepr]
		public struct sockaddr
		{
		    public sa_family_t sa_family;
		    public char8[14]   sa_data;
		}

		[CRepr]
		public struct in_addr
		{
		    public uint32 s_addr; /* address in network byte order */
		}

		[CRepr]
		public struct sockaddr_in
		{
		    public sa_family_t sin_family; /* address family: AF_INET */
		    public in_port_t   sin_port;   /* port in network byte order */
		    public in_addr     sin_addr;   /* internet address */
		}

		[CRepr]
		public struct in6_addr
		{
		    public uint8[16] s6_addr; /* address in network byte order */
		}

		[CRepr]
		public struct sockaddr_in6
		{
		    public sa_family_t sin6_family;   /* address family: AF_INET6 */
		    public in_port_t   sin6_port;     /* port in network byte order */
		    public uint32      sin6_flowinfo; /* IPv6 traffic class and flow information */
		    public in6_addr    sin6_addr;     /* IPv6 address */
		    public uint32      sin6_scope_id; /* set of interfaces for a scope */
		}

		[CRepr]
		public struct sockaddr_un
		{
		    public sa_family_t sun_family; /* address family: AF_UNIX */
		    public char8[]     sun_path;   /* socket pathname */
		}
#else
	#error Unsupported platform
#endif
		[Inline]
		public static char8* h_addr(hostent h) => h.h_addr_list[0];
	}
}
