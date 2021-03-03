using System;
using Beef_OpenSSL;

namespace Beef_OpenSSL_Test
{
	class Prefix
	{
		[CRepr]
		struct prefix_ctx_st
		{
		    public char8* prefix;
		    public bool linestart; /* flag to indicate we're at the line start */
		}
		typealias PREFIX_CTX = prefix_ctx_st;

		static BIO.METHOD* prefix_meth = null;

		public const int PREFIX_CTRL_SET_PREFIX = 1 << 15;

		public static BIO.METHOD* apps_bf_prefix()
		{
		    if (prefix_meth == null) {
		        if (
					(prefix_meth = BIO.meth_new(BIO.TYPE_FILTER, "Prefix filter")) == null ||
					!BIO.meth_set_create(prefix_meth, => prefix_create) ||
					!BIO.meth_set_destroy(prefix_meth, => prefix_destroy) ||
					!BIO.meth_set_write_ex(prefix_meth, => prefix_write) ||
					!BIO.meth_set_read_ex(prefix_meth, => prefix_read) ||
					!BIO.meth_set_puts(prefix_meth, => prefix_puts) ||
					!BIO.meth_set_gets(prefix_meth, => prefix_gets) ||
					!BIO.meth_set_ctrl(prefix_meth, => prefix_ctrl) ||
					!BIO.meth_set_callback_ctrl(prefix_meth, => prefix_callback_ctrl)
				) {
		            BIO.meth_free(prefix_meth);
		            prefix_meth = null;
		        }
		    }

		    return prefix_meth;
		}

		static int prefix_create(BIO.bio_st* b)
		{
		    PREFIX_CTX* ctx = (PREFIX_CTX*)OpenSSL.zalloc(sizeof(PREFIX_CTX*));

		    if (ctx == null)
		        return 0;

		    ctx.prefix = null;
		    ctx.linestart = true;
		    BIO.set_data(b, ctx);
		    BIO.set_init(b, 1);
		    return 1;
		}

		static int prefix_destroy(BIO.bio_st* b)
		{
		    PREFIX_CTX* ctx = (PREFIX_CTX*)BIO.get_data(b);

		    OpenSSL.free(ctx.prefix);
		    OpenSSL.free(ctx);
		    return 1;
		}

		static int prefix_read(BIO.bio_st* b, char8* inVal, uint size, uint* numread)
		{
		    return BIO.read_ex(BIO.next(b), inVal, size, numread);
		}

		static int prefix_write(BIO.bio_st* b, char8* outVal, uint outl, uint* numwritten)
		{
			var outVal;
			var outl;
		    PREFIX_CTX* ctx = (PREFIX_CTX*)BIO.get_data(b);

		    if (ctx == null)
		        return 0;

		    /* If no prefix is set or if it's empty, we've got nothing to do here */
		    if (ctx.prefix == null || *ctx.prefix == '\0') {
		        /* We do note if what comes next will be a new line, though */
		        if (outl > 0)
		            ctx.linestart = (outVal[outl-1] == '\n');

		        return BIO.write_ex(BIO.next(b), outVal, outl, numwritten);
		    }

		    *numwritten = 0;

		    while (outl > 0) {
		        uint i;
		        char8 c;

		        /* If we know that we're at the start of the line, output the prefix */
		        if (ctx.linestart) {
		            uint dontcare;
					String tmp = scope:: .(ctx.prefix);

		            if (BIO.write_ex(BIO.next(b), ctx.prefix, (uint)tmp.Length, &dontcare) <= 0)
		                return 0;

		            ctx.linestart = false;
		        }

		        /* Now, go look for the next LF, or the end of the string */
		        for (i = 0, c = '\0'; i < outl && (c = outVal[i]) != '\n'; i++)
		            continue;
		        if (c == '\n')
		            i++;

		        /* Output what we found so far */
		        while (i > 0) {
		            uint num = 0;

		            if (BIO.write_ex(BIO.next(b), outVal, i, &num) <= 0)
		                return 0;

		            outVal += num;
		            outl -= num;
		            *numwritten += num;
		            i -= num;
		        }

		        /* If we found a LF, what follows is a new line, so take note */
		        if (c == '\n')
		            ctx.linestart = true;
		    }

		    return 1;
		}

		static bool prefix_ctrl(BIO.bio_st* b, int cmd, int num, void* ptr)
		{
		    bool ret = false;

		    switch (cmd) {
		    case PREFIX_CTRL_SET_PREFIX:
		        {
		            PREFIX_CTX* ctx = (PREFIX_CTX*)BIO.get_data(b);

		            if (ctx == null)
		                break;

		            OpenSSL.free(ctx.prefix);
		            ctx.prefix = OpenSSL.strdup((char8*)ptr);
		            ret = ctx.prefix != null;
		        }
		        break;
		    default:
		        if (BIO.next(b) != null)
		            ret = BIO.ctrl(BIO.next(b), cmd, num, ptr) > 0;

		        break;
		    }
		    return ret;
		}

		static int prefix_callback_ctrl(BIO.bio_st* b, int cmd, BIO.info_cb* fp)
		{
		    return BIO.callback_ctrl(BIO.next(b), cmd, fp);
		}

		static int prefix_gets(BIO.bio_st* b, char8* buf, int size)
		{
		    return BIO.gets(BIO.next(b), buf, size);
		}

		static int prefix_puts(BIO.bio_st* b, char8* str)
		{
			String tmp = scope:: .(str);
		    return BIO.write(b, str, tmp.Length);
		}
	}
}
