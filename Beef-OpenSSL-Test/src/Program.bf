using System;
using System.Collections;
using System.IO;
using System.Threading;
using Beef_OpenSSL;

namespace Beef_OpenSSL_Test
{
	class Program
	{
		public const int32 B_FORMAT_TEXT  = 0x8000;
		public const int32 FORMAT_UNDEF   = 0;
		public const int32 FORMAT_TEXT    = 1 | B_FORMAT_TEXT;     /* Generic text */
		public const int32 FORMAT_BINARY  = 2;                     /* Generic binary */
		public const int32 FORMAT_BASE64  = 3 | B_FORMAT_TEXT;     /* Base64 */
		public const int32 FORMAT_ASN1    = 4;                     /* ASN.1/DER */
		public const int32 FORMAT_PEM     = 5 | B_FORMAT_TEXT;
		public const int32 FORMAT_PKCS12  = 6;
		public const int32 FORMAT_SMIME   = 7 | B_FORMAT_TEXT;
		public const int32 FORMAT_ENGINE  = 8;                     /* Not really a file format */
		public const int32 FORMAT_PEMRSA  = 9 | B_FORMAT_TEXT;     /* PEM RSAPubicKey format */
		public const int32 FORMAT_ASN1RSA = 10;                    /* DER RSAPubicKey format */
		public const int32 FORMAT_MSBLOB  = 11;                    /* MS Key blob format */
		public const int32 FORMAT_PVK     = 12;                    /* MS PVK file format */
		public const int32 FORMAT_HTTP    = 13;                    /* Download using HTTP */
		public const int32 FORMAT_NSS     = 14;                    /* NSS keylog format */

		struct DISPLAY_COLUMNS
		{
		    public int columns;
		    public int width;
		}
		
		enum HELP_CHOICE : int
		{
		    OPT_hERR = -1,
			OPT_hEOF = 0,
			OPT_hHELP
		}

		public static OPTIONS[?] help_options = .(
		    .(OsslOpt.HELP_STR, 1, '-', "Usage: help [options]\n"),
		    .(OsslOpt.HELP_STR, 1, '-', "       help [command]\n"),
		    .("help", HELP_CHOICE.OPT_hHELP.Underlying, '-', "Display this summary"),
		    .(null, 0, 0, null)
		);

		static Dictionary<String, String> mEnvironmentVariables = new .() ~ DeleteDictionaryAndKeysAndValues!(_);

		static BIO.METHOD* prefix_method = null;
		static UI.METHOD* ui_method = null;
		static UI.METHOD* ui_fallback_method = null;

		public static BIO.bio_st* bio_out = null;
		public static BIO.bio_st* bio_err = null;
		public static BIO.bio_st* bio_in = null;

		static String OPENSSL_CONF = "openssl.cnf";

		static String default_config_file;

		static int Main(String[] args)
		{
			int ret = 0;
			String pname = scope:: .();

			Environment.GetEnvironmentVariables(mEnvironmentVariables);

			default_config_file = new String();
			make_config_name(default_config_file);
			
			Thread.Sleep(10);
			bio_out = dup_bio_out(FORMAT_TEXT);
			bio_err = dup_bio_err(FORMAT_TEXT);
			bio_in = dup_bio_in(FORMAT_TEXT);

		    String p = mEnvironmentVariables.GetValueOrDefault("OPENSSL_DEBUG_MEMORY");

		    if (p != default && p.Equals("on", .OrdinalIgnoreCase))
		        Crypto.set_mem_debug(1);

		    Crypto.mem_ctrl(Crypto.MEM_CHECK_ON);
			BIO.printf(bio_out, "App args:\n[\n");

			for (int i = 0; i < args.Count; i++)
				BIO.printf(bio_out, "  %d - %s\n", i, args[i].CStr());

			BIO.printf(bio_out, "]\n\n");
		
		    if (mEnvironmentVariables.GetValueOrDefault("OPENSSL_FIPS") != default) {
		        BIO.printf(bio_err, "FIPS mode not supported.\n");
		        return 1;
		    }

			// OpenSSL.init();
			OpenSSL.init_ssl(OpenSSL.INIT_ENGINE_ALL_BUILTIN | OpenSSL.INIT_LOAD_CONFIG, null);

			prog_init();

			if (prog_init_ret.IsEmpty) {
			    BIO.printf(bio_err, "FATAL: Startup failure (dev note: prog_init() failed)\n");
				Error.print_errors(bio_err);
			    return End(1);
			}

			OsslOpt.Progname(pname);
		    /* first check the program name */
			int fIdx = prog_init_ret.FindIndex(scope:: [&] (val) => { return val.name.Equals(pname); });

		    if (fIdx > -1) {
				ret = prog_init_ret[fIdx].func(args);
		        return End(ret);
		    }

		    /* If there is stuff on the command line, run with that. */
		    if (!args.IsEmpty) {
		        ret = do_cmd(args);

		        if (ret < 0)
		            ret = 0;

		        return End(ret);
		    }
			
			String tmp = scope:: .(AES.options());
			tmp.Append("\n\nOpenSSL.VERSION     = ");
			tmp.Append(OpenSSL.version(OpenSSL.VERSION));
			tmp.Append("\nOpenSSL.CFLAGS      = ");
			tmp.Append(OpenSSL.version(OpenSSL.CFLAGS));
			tmp.Append("\nOpenSSL.BUILT_ON    = ");
			tmp.Append(OpenSSL.version(OpenSSL.BUILT_ON));
			tmp.Append("\nOpenSSL.PLATFORM    = ");
			tmp.Append(OpenSSL.version(OpenSSL.PLATFORM));
			tmp.Append("\nOpenSSL.DIR         = ");
			tmp.Append(OpenSSL.version(OpenSSL.DIR));
			tmp.Append("\nOpenSSL.ENGINES_DIR = ");
			tmp.Append(OpenSSL.version(OpenSSL.ENGINES_DIR));
			// Console.Out.WriteLine(tmp);
			BIO.printf(bio_out, "%s\n", tmp.CStr());

			return End(ret);
		}

		static int End(int retVal)
		{
			// Console.Out.WriteLine("\nPress [Enter]  to exit...");
			BIO.printf(bio_out, "\nPress [Enter]  to exit...");

			// Console.In.Read();
			char8[] dump = scope:: char8[1 * sizeof(char8)];
			BIO.read(bio_in, dump.CArray(), dump.Count);

			delete default_config_file;
			BIO.free(bio_in);
			BIO.free_all(bio_out);

			if (ui_method != null) {
			    UI.destroy_method(ui_method);
			    ui_method = null;
			}

			if (prefix_method != null) {
				BIO.meth_free(prefix_method);
				prefix_method = null;
			}

			BIO.free(bio_err);
			OpenSSL.cleanup();
			return retVal;
		}

		static bool istext(int format) => (format & B_FORMAT_TEXT) == B_FORMAT_TEXT;

		static BIO.bio_st* dup_bio_in(int format)
		{
			Platform.BfpFileResult result = .Ok;
			Platform.BfpFile* fp = Platform.BfpFile_GetStd(.In, &result);

			if (result != .Ok) {
				Console.Error.WriteLine("Unable to retrieve STDIN handle");
				return null;
			}

		    return BIO.new_fp(fp, BIO.NOCLOSE | (istext(format) ? BIO.FP_TEXT : 0));
		}

		static BIO.bio_st* dup_bio_out(int format)
		{
			Platform.BfpFileResult result = .Ok;
			Platform.BfpFile* fp = Platform.BfpFile_GetStd(.Out, &result);

			if (result != .Ok) {
				Console.Error.WriteLine("Unable to retrieve STDOUT handle");
				return null;
			}

			bool isText = istext(format);
		    BIO.bio_st* b = BIO.new_fp(fp, BIO.NOCLOSE | (isText ? BIO.FP_TEXT : 0));
			String prefix;

			if (isText && (prefix = mEnvironmentVariables.GetValueOrDefault("HARNESS_OSSL_PREFIX")) != default) {
			    if (prefix_method == null)
			        prefix_method = Prefix.apps_bf_prefix();

			    b = BIO.push(BIO.new_(prefix_method), b);
			    BIO.ctrl(b, Prefix.PREFIX_CTRL_SET_PREFIX, 0, prefix.CStr());
			}

			return b;
		}

		static BIO.bio_st* dup_bio_err(int format)
		{
			Platform.BfpFileResult result = .Ok;
			Platform.BfpFile* fp = Platform.BfpFile_GetStd(.Error, &result);

			if (result != .Ok) {
				Console.Error.WriteLine("Unable to retrieve STDOUT handle");
				return null;
			}

		    return BIO.new_fp(fp, BIO.NOCLOSE | (istext(format) ? BIO.FP_TEXT : 0));
		}

		static void calculate_columns(ref DISPLAY_COLUMNS dc)
		{
		    FUNCTION f;
		    int len, maxlen = 0;

			for (int i = 0; i < functions.Count; i++) {
				f = functions[i];

				if (f.name == null)
					continue;

				if (f.type == .FT_general || f.type == .FT_md || f.type == .FT_cipher)
					if ((len = f.name.Length) > maxlen)
					    maxlen = len;
			}
		
		    dc.width = maxlen + 2;
		    dc.columns = (80 - 1) / dc.width;
		}

		static void make_config_name(String outStr)
		{
		    String t = scope:: .();
		
		    if ((t = mEnvironmentVariables.GetValueOrDefault("OPENSSL_CONF")) != default) {
				outStr.Set(t);
				return;
			}

			outStr.Clear();
			outStr.Append(X509.get_default_cert_area());
#if !OPENSSL_SYS_VMS
			outStr.Append("/");
#endif
			outStr.Append(OPENSSL_CONF);
		}

		static int do_cmd(String[] args)
		{
		    FUNCTION f = .();
			int fIdx;

		    if (args.IsEmpty || args[0] == null)
		        return 0;

			f.name = scope:: .(args[0]);
		    fIdx = prog_init_ret.FindIndex(scope:: [&] (val) => { return val.name.Equals(f.name); });

		    if (fIdx == -1) {
		        if (EVP.get_digestbyname(args[0].CStr()) != null) {
		            f.type = .FT_md;
		            f.func = => dgst_main;
		        } else if (EVP.get_cipherbyname(args[0].CStr()) != null) {
		            f.type = .FT_cipher;
		            f.func = => enc_main;
		        }
		    }

		    if (fIdx > -1) {
				f = prog_init_ret[fIdx];
		        return f.func(args);
		    }

		    if (args[0].StartsWith("no-")) {
		        /* User is asking if foo is unsupported, by trying to "run" the no-foo command.  Strange. */
		        f.name = scope:: .(args[0]);
				f.name.Remove(0, 3);

		    	fIdx = prog_init_ret.FindIndex(scope:: [&] (val) => { return val.name.Equals(f.name); });

		        if (fIdx == -1) {
		            BIO.printf(bio_out, "%s\n", args[0].CStr());
		            return 0;
		        }

				args[0].Remove(0, 3);
		        BIO.printf(bio_out, "%s\n", f.name);
		        return 1;
		    }

		    if (args[0].Equals("quit") || args[0].Equals("q") || args[0].Equals("exit") || args[0].Equals("bye"))
		        /* Special value to mean "exit the program. */
		        return -1;

		    BIO.printf(bio_err, "Invalid command '%s'; type \"help\" for a list.\n", args[0].CStr());
		    return 1;
		}

		static int dgst_main(String[] args)
		{
			return 0;
		}

		static int enc_main(String[] args)
		{
			return 0;
		}

		public static int help_main(String[] args)
		{
		    FUNCTION fp;
		    int i;
			bool nl;
		    FUNC_TYPE tp;
		    String prog = scope:: .();
		    HELP_CHOICE o;
    		DISPLAY_COLUMNS dc = .();

			OsslOpt.Init(args, help_options, prog);
		    while ((o = (HELP_CHOICE)OsslOpt.Next()) != .OPT_hEOF) {
		        switch (o) {
		        case .OPT_hERR:
		        case .OPT_hEOF:
		            BIO.printf(bio_err, "%s: Use -help for summary.\n", prog.CStr());
		            return 1;
		        case .OPT_hHELP:
		            OsslOpt.Help(help_options);
		            return 0;
		        }
		    }

		    if (OsslOpt.NumRest() == 1) {
				Span<String> rest = .();
				OsslOpt.Rest(rest);
		        String[] new_args = new .[3](rest[0], "--help", null);
				prog_init();
		        return do_cmd(new_args);
		    }

		    if (OsslOpt.NumRest() != 0) {
		        BIO.printf(bio_err, "Usage: %s\n", prog);
		        return 1;
		    }

			calculate_columns(ref dc);
		    BIO.printf(bio_err, "Standard commands");
		    i = 0;
		    tp = .FT_none;

			for (int j = 0; j < functions.Count; j++) {
				fp = functions[j];
		        nl = false;

				if (fp.name == null)
					continue;

		        if (i++ % dc.columns == 0) {
		            BIO.printf(bio_err, "\n");
		            nl = true;
		        }

		        if (fp.type != tp) {
		            tp = fp.type;

		            if (!nl)
		                BIO.printf(bio_err, "\n");
		            if (tp == .FT_md) {
		                i = 1;
		                BIO.printf(bio_err, "\nMessage Digest commands (see the `dgst' command for more details)\n");
		            } else if (tp == .FT_cipher) {
		                i = 1;
		                BIO.printf(bio_err, "\nCipher commands (see the `enc' command for more details)\n");
		            }
		        }
		        BIO.printf(bio_err, "%-*s", dc.width, fp.name.CStr());
		    }

		    BIO.printf(bio_err, "\n\n");
		    return 0;
		}
		
		static List<FUNCTION> prog_init_ret = new .() ~ delete _;
		static bool prog_inited = false;
		static void prog_init()
		{
		    if (prog_inited)
		        return;
		
		    prog_inited = true;
			FUNCTION f;

			for (int i = 0; i < functions.Count; i++) {
				f = functions[i];

				if (f.name == null)
					continue;

				prog_init_ret.Add(f);
			}

		    prog_init_ret.Sort(scope:: [&] (lhs, rhs) => {
				return lhs.name.CompareTo(rhs.name);
			});
		}
	}
}
