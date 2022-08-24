using System;
using System.IO;
using Beef_OpenSSL;

namespace Beef_OpenSSL_Test
{
	public struct string_int_pair_st
	{
	    public String name;
	    public int retval;

		public this(String name, int retval)
		{
			this.name = name;
			this.retval = retval;
		}
	}
	public typealias OPT_PAIR = string_int_pair_st;
	public typealias STRINT_PAIR = string_int_pair_st;

	sealed static class OsslOpt
	{
		public const int MAX_OPT_HELP_WIDTH = 30;
		public const String HELP_STR = "--";
		public const String MORE_STR = "---";

		/* Flags to pass into opt_format; see FORMAT_xxx, below. */
		public const uint32 OPT_FMT_PEMDER = 1L <<  1;
		public const uint32 OPT_FMT_PKCS12 = 1L <<  2;
		public const uint32 OPT_FMT_SMIME  = 1L <<  3;
		public const uint32 OPT_FMT_ENGINE = 1L <<  4;
		public const uint32 OPT_FMT_MSBLOB = 1L <<  5;
		/* (1L <<  6) was OPT_FMT_NETSCAPE, but wasn't used */
		public const uint32 OPT_FMT_NSS    = 1L <<  7;
		public const uint32 OPT_FMT_TEXT   = 1L <<  8;
		public const uint32 OPT_FMT_HTTP   = 1L <<  9;
		public const uint32 OPT_FMT_PVK    = 1L << 10;
		public const uint32 OPT_FMT_PDE    = OPT_FMT_PEMDER | OPT_FMT_ENGINE;
		public const uint32 OPT_FMT_PDS    = OPT_FMT_PEMDER | OPT_FMT_SMIME;
		public const uint32 OPT_FMT_ANY    = OPT_FMT_PEMDER | OPT_FMT_PKCS12 | OPT_FMT_SMIME | OPT_FMT_ENGINE | OPT_FMT_MSBLOB | OPT_FMT_NSS | OPT_FMT_TEXT | OPT_FMT_HTTP | OPT_FMT_PVK;

		static OPT_PAIR[?] formats = .(
		    .("PEM/DER", OPT_FMT_PEMDER),
		    .("pkcs12", OPT_FMT_PKCS12),
		    .("smime", OPT_FMT_SMIME),
		    .("engine", OPT_FMT_ENGINE),
		    .("msblob", OPT_FMT_MSBLOB),
		    .("nss", OPT_FMT_NSS),
		    .("text", OPT_FMT_TEXT),
		    .("http", OPT_FMT_HTTP),
		    .("pvk", OPT_FMT_PVK),
		    .(null, 0)
		);

	    static String[] args;
	    static int opt_index;
		static String arg;
		static String flag;
		static String dunno;
	    static Span<OPTIONS> opts;
	    static OPTIONS currOption;
	    static OPTIONS unknown;
		static String prog = new .() ~ delete _;

		static void Progname()
		{
		    String p = scope:: .();

			Environment.GetExecutableFilePath(p);
			prog.Clear();
			Path.GetFileName(p, prog);
			prog.ToLower();
		}

		public static void Progname(String outStr)
		{
		    if (prog.IsEmpty)
				Progname();

			outStr.Set(prog);
		}

		/* Set up the arg parsing. */
		public static void Init(String[] argArr, Span<OPTIONS> o, String outStr)
		{
		    /* Store state. */
		    args = argArr;
		    opt_index = 0;
		    opts = o;
		    currOption = default;
    		Progname();
		    unknown = default;

			for (int i = 0; i < opts.Length; i++) {
				currOption = opts[i];

				if (currOption.name == null)
					continue;

#if !NDEBUG
		        OPTIONS next;
		        bool duplicated;
				char8 j;
#endif

		        if (currOption.name == OsslOpt.HELP_STR || currOption.name == OsslOpt.MORE_STR)
		            continue;
#if !NDEBUG
		        j = currOption.valtype;

		        /* Make sure options are legit. */
		        //assert(currOption.name[0] != '-');
		        //assert(currOption.retval > 0);
		        switch (j) {
		        case   0: case '-': case '/': case '<': case '>': case 'E': case 'F':
		        case 'M': case 'U': case 'f': case 'l': case 'n': case 'p': case 's':
		        case 'u': case 'c':
		            break;
		        default:
		            continue;
		        }

		        /* Make sure there are no duplicates. */
				for (int k = i + 1; k < opts.Length; k++) {
					next = opts[k];

					if (next.name == null)
						continue;

		            /* Some compilers inline strcmp and the assert string is too long. */
		            duplicated = currOption.name.Equals(next.name);
		            //assert(!duplicated);
		        }
#endif
		        if (currOption.name[0] == '\0') {
		            //assert(unknown == NULL);
		            unknown = currOption;
		            //assert(unknown->valtype == 0 || unknown->valtype == '-');
		        }
		    }

		    outStr.Set(prog);
		}

		/*
		 * Parse the next flag (and value if specified), return 0 if done, -1 on
		 * error, otherwise the flag's retval.
		 */
		public static int Next()
		{
		    String p;
		    OPTIONS o;
		    int ival = 0;
		    int32 lval;
		    uint32 ulval;
		    int32 imval;
		    uint32 umval;

		    /* Look at current arg; at end of the list? */
		    arg = default;
		    p = args[opt_index];

		    if (p == null)
		        return 0;

		    /* If word doesn't start with a -, we're done. */
		    if (!p.StartsWith('-'))
		        return 0;

		    /* Hit "--" ? We're done. */
		    opt_index++;
		    if (p.Equals(HELP_STR))
		        return 0;
			
			/* Allow -nnn and --nnn */
			p.Remove(0, p.StartsWith("--") ? 2 : 1);

		    /* If we have --flag=foo, snip it off */
			if (p.Contains('='))
				arg.Set(p.Substring(p.IndexOf('=') + 1));

			for (int i = 0; i < opts.Length; i++) {
				o = opts[i];

				if (o.name == null)
					continue;

		        /* If not this option, move on to the next one. */
		        if (p.Equals(o.name))
		            continue;

		        /* If it doesn't take a value, make sure none was given. */
		        if (o.valtype == 0 || o.valtype == '-') {
		            if (arg != default) {
		                BIO.printf(Program.bio_err, "%s: Option -%s does not take a value\n", prog.CStr(), p.CStr());
		                return -1;
		            }

		            return o.retval;
		        }

		        /* Want a value; get the next param if =foo not used. */
		        if (arg == default) {
		            if (args[opt_index] == null) {
		                BIO.printf(Program.bio_err, "%s: Option -%s needs a value\n", prog.CStr(), o.name.CStr());
		                return -1;
		            }

		            arg = args[opt_index++];
		        }

		        /* Syntax-check value. */
		        switch (o.valtype) {
		        case 's':
		            /* Just a string. */
		            break;
		        case '/':
		            if (Directory.Exists(arg))
		                break;
		            BIO.printf(Program.bio_err, "%s: Not a directory: %s\n", prog.CStr(), arg.CStr());
		            return -1;
		        case '<':
		            /* Input file. */
		            break;
		        case '>':
		            /* Output file. */
		            break;
		        case 'p':
		        case 'n':
					
		            if ((ival = TrySilent!(Int.Parse(arg))) == default || (o.valtype == 'p' && ival <= 0)) {
		                BIO.printf(Program.bio_err, "%s: Non-positive number \"%s\" for -%s\n", prog.CStr(), arg.CStr(), o.name.CStr());
		                return -1;
		            }
		            break;
		        case 'M':
		            if ((imval = TrySilent!(Int32.Parse(arg))) == default) {
		                BIO.printf(Program.bio_err, "%s: Invalid number \"%s\" for -%s\n", prog.CStr(), arg.CStr(), o.name.CStr());
		                return -1;
		            }
		            break;
		        case 'U':
		            if ((umval = TrySilent!(UInt32.Parse(arg))) == default) {
		                BIO.printf(Program.bio_err, "%s: Invalid number \"%s\" for -%s\n", prog.CStr(), arg.CStr(), o.name.CStr());
		                return -1;
		            }
		            break;
		        case 'l':
		            if ((lval = TrySilent!(Int32.Parse(arg))) == default) {
		                BIO.printf(Program.bio_err, "%s: Invalid number \"%s\" for -%s\n", prog.CStr(), arg.CStr(), o.name.CStr());
		                return -1;
		            }
		            break;
		        case 'u':
		            if ((ulval = TrySilent!(UInt32.Parse(arg))) == default) {
		                BIO.printf(Program.bio_err, "%s: Invalid number \"%s\" for -%s\n", prog.CStr(), arg.CStr(), o.name.CStr());
		                return -1;
		            }
		            break;
		        case 'c':
		        case 'E':
		        case 'F':
		        case 'f':
		            if (Format(arg, o.valtype == 'c' ? OPT_FMT_PDS :
		                           o.valtype == 'E' ? OPT_FMT_PDE :
		                           o.valtype == 'F' ? OPT_FMT_PEMDER
		                           : OPT_FMT_ANY, ref ival))
		                break;
		            BIO.printf(Program.bio_err, "%s: Invalid format \"%s\" for -%s\n", prog.CStr(), arg.CStr(), o.name.CStr());
		            return -1;
		        default:
		            /* Just a string. */
		            break;
		        }

		        /* Return the flag value. */
		        return o.retval;
		    }

		    if (unknown != default) {
		        dunno = p;
		        return unknown.retval;
		    }

		    BIO.printf(Program.bio_err, "%s: Option unknown option -%s\n", prog, p);
		    return -1;
		}

		/* Print an error message about a failed format parse. */
		static bool FormatError(String s, uint32 flags)
		{
		    OPT_PAIR ap;
		
		    if (flags == OPT_FMT_PEMDER) {
		        BIO.printf(Program.bio_err, "%s: Bad format \"%s\"; must be pem or der\n", prog.CStr(), s.CStr());
		    } else {
		        BIO.printf(Program.bio_err, "%s: Bad format \"%s\"; must be one of:\n", prog.CStr(), s.CStr());

				for (int i = 0; i < formats.Count; i++) {
					ap = formats[i];

					if (ap.name == null)
						continue;
					
					if (flags & ap.retval > 0)
					    BIO.printf(Program.bio_err, "   %s\n", ap.name.CStr());
				}
		    }

		    return false;
		}
		
		/* Parse a format string, put it into *result; return 0 on failure, else 1. */
		static bool Format(String s, uint32 flags, ref int result)
		{
		    switch (s[0]) {
		    case 'D':
		    case 'd':
		        if ((flags & OPT_FMT_PEMDER) == 0)
		            return FormatError(s, flags);

		        result = Program.FORMAT_ASN1;
		        break;
		    case 'T':
		    case 't':
		        if ((flags & OPT_FMT_TEXT) == 0)
		            return FormatError(s, flags);

		        result = Program.FORMAT_TEXT;
		        break;
		    case 'N':
		    case 'n':
		        if ((flags & OPT_FMT_NSS) == 0)
		            return FormatError(s, flags);

		        if (s.Equals("NSS", .OrdinalIgnoreCase))
		            return FormatError(s, flags);

		        result = Program.FORMAT_NSS;
		        break;
		    case 'S':
		    case 's':
		        if ((flags & OPT_FMT_SMIME) == 0)
		            return FormatError(s, flags);

		        result = Program.FORMAT_SMIME;
		        break;
		    case 'M':
		    case 'm':
		        if ((flags & OPT_FMT_MSBLOB) == 0)
		            return FormatError(s, flags);

		        result = Program.FORMAT_MSBLOB;
		        break;
		    case 'E':
		    case 'e':
		        if ((flags & OPT_FMT_ENGINE) == 0)
		            return FormatError(s, flags);

		        result = Program.FORMAT_ENGINE;
		        break;
		    case 'H':
		    case 'h':
		        if ((flags & OPT_FMT_HTTP) == 0)
		            return FormatError(s, flags);

		        result = Program.FORMAT_HTTP;
		        break;
		    case '1':
		        if ((flags & OPT_FMT_PKCS12) == 0)
		            return FormatError(s, flags);

		        result = Program.FORMAT_PKCS12;
		        break;
		    case 'P':
		    case 'p':
		        if (s[1] == '\0' || s.Equals("PEM", .OrdinalIgnoreCase)) {
		            if ((flags & OPT_FMT_PEMDER) == 0)
		                return FormatError(s, flags);

		            result = Program.FORMAT_PEM;
		        } else if (s.Equals("PVK", .OrdinalIgnoreCase)) {
		            if ((flags & OPT_FMT_PVK) == 0)
		                return FormatError(s, flags);

		            result = Program.FORMAT_PVK;
		        } else if (s.Equals("P12", .OrdinalIgnoreCase) || s.Equals("PKCS12", .OrdinalIgnoreCase)) {
		            if ((flags & OPT_FMT_PKCS12) == 0)
		                return FormatError(s, flags);

		            result = Program.FORMAT_PKCS12;
		        } else {
		            return false;
		        }
		        break;
		    default:
		        return false;
		    }

		    return true;
		}

		/* Return a string describing the parameter type. */
		static StringView valtype2param(OPTIONS o)
		{
		    switch (o.valtype) {
		    case 0:
		    case '-':
		        return "";
		    case 's':
		        return "val";
		    case '/':
		        return "dir";
		    case '<':
		        return "infile";
		    case '>':
		        return "outfile";
		    case 'p':
		        return "+int";
		    case 'n':
		        return "int";
		    case 'l':
		        return "long";
		    case 'u':
		        return "ulong";
		    case 'E':
		        return "PEM|DER|ENGINE";
		    case 'F':
		        return "PEM|DER";
		    case 'f':
		        return "format";
		    case 'M':
		        return "intmax";
		    case 'U':
		        return "uintmax";
		    }
		    return "parm";
		}

		public static void Help(Span<OPTIONS> list)
		{
		    OPTIONS o;
		    int i;
		    bool standard_prolog;
		    int width = 5;
		    String start = scope:: .(' ', 80); /* Prefix padding */
		    String p = scope:: .();
		    String help = scope:: .();
			String startCut = scope:: .();

		    /* Starts with its own help message? */
		    standard_prolog = !list[0].name.Equals(HELP_STR);

		    /* Find the widest help. */
			for (int j = 0; j < list.Length; j++) {
				o = list[j];

				if (o.name == null)
					continue;

		        if (o.name.Equals(MORE_STR))
		            continue;

		        i = 2 + o.name.Length;

		        if (o.valtype != '-')
		            i += 1 + valtype2param(o).Length;

		        if (i < MAX_OPT_HELP_WIDTH && i > width)
		            width = i;

		        //assert(i < (int)sizeof(start));
		    }

		    if (standard_prolog)
		        BIO.printf(Program.bio_err, "Usage: %s [options]\nValid options are:\n", prog.CStr());

		    /* Now let's print. */
			for (int j = 0; j < list.Length; j++) {
				o = list[j];

				if (o.name == null)
					continue;

		        help.Set(o.helpstr != null ? o.helpstr : "(No additional info)");

		        if (o.name.Equals(HELP_STR)) {
		            BIO.printf(Program.bio_err, help.CStr(), prog.CStr());
		            continue;
		        }

				startCut.Set(start);

		        if (o.name.Equals(MORE_STR)) {
		            /* Continuation of previous line; pad and print. */
					startCut.Set(startCut.Substring(0, width));
		            BIO.printf(Program.bio_err, "%s  %s\n", startCut.CStr(), help.CStr());
		            continue;
		        }

		        /* Build up the "-flag [param]" part. */
		        p.Set(start);
		        p.Append(" -");

		        if (o.name[0] > 0)
					p.Append(o.name);
		        else
		            p.Append('*');

		        if (o.valtype != '-') {
		            p.Append(' ');
		            p.Append(valtype2param(o));
		        }

		        p.Append(' ');

		        if ((p.Length - startCut.Length) >= MAX_OPT_HELP_WIDTH) {
		            BIO.printf(Program.bio_err, "%s\n", startCut.CStr());
					startCut.Set(start);
		        }

				startCut.Set(startCut.Substring(0, width));
		        BIO.printf(Program.bio_err, "%s  %s\n", startCut.CStr(), help.CStr());
		    }
		}

		/* Return the rest of the arguments after parsing flags. */
		public static void Rest(Span<String> outVal)
		{
			args.CopyTo(outVal, opt_index);
		}
		
		/* How many items in remaining args? */
		public static int NumRest()
		{
		    int i = 0;
			Span<String> rest = .();
			Rest(rest);

		    for (var str in rest) {
				if (str != null && !str.IsEmpty)
					i++;
			}

		    return i;
		}
	}
}
