using System;
using System.Collections;
using Beef_OpenSSL;

namespace Beef_OpenSSL_Test
{
	class Program
	{
		const int B_FORMAT_TEXT  = 0x8000;
		const int FORMAT_UNDEF   = 0;
		const int FORMAT_TEXT    = 1 | B_FORMAT_TEXT;     /* Generic text */
		const int FORMAT_BINARY  = 2;                     /* Generic binary */
		const int FORMAT_BASE64  = 3 | B_FORMAT_TEXT;     /* Base64 */
		const int FORMAT_ASN1    = 4;                     /* ASN.1/DER */
		const int FORMAT_PEM     = 5 | B_FORMAT_TEXT;
		const int FORMAT_PKCS12  = 6;
		const int FORMAT_SMIME   = 7 | B_FORMAT_TEXT;
		const int FORMAT_ENGINE  = 8;                     /* Not really a file format */
		const int FORMAT_PEMRSA  = 9 | B_FORMAT_TEXT;     /* PEM RSAPubicKey format */
		const int FORMAT_ASN1RSA = 10;                    /* DER RSAPubicKey format */
		const int FORMAT_MSBLOB  = 11;                    /* MS Key blob format */
		const int FORMAT_PVK     = 12;                    /* MS PVK file format */
		const int FORMAT_HTTP    = 13;                    /* Download using HTTP */
		const int FORMAT_NSS     = 14;                    /* NSS keylog format */

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

		static Dictionary<String, String> mEnvironmentVariables = new .() ~ DeleteDictionaryAndKeysAndValues!(_);

		static BIO.METHOD* prefix_method = null;
		static UI.METHOD* ui_method = null;
		static UI.METHOD* ui_fallback_method = null;

		static BIO.bio_st* bio_in = null;
		static BIO.bio_st* bio_out = null;
		static BIO.bio_st* bio_err = null;

		static String OPENSSL_CONF = "openssl.cnf";

		static String default_config_file;

		static int Main(String[] args)
		{
			int ret = 0;

			// OpenSSL.init();
			OpenSSL.init_ssl(OpenSSL.INIT_ENGINE_ALL_BUILTIN | OpenSSL.INIT_LOAD_CONFIG, null);

			Environment.GetEnvironmentVariables(mEnvironmentVariables);

			default_config_file = new String();
			make_config_name(default_config_file);

			bio_in = dup_bio_in(FORMAT_TEXT);
			bio_out = dup_bio_out(FORMAT_TEXT);
			bio_err = dup_bio_err(FORMAT_TEXT);

		    String p = mEnvironmentVariables.GetValueOrDefault("OPENSSL_DEBUG_MEMORY");

		    if (p != default && p.Equals("on", .OrdinalIgnoreCase))
		        Crypto.set_mem_debug(1);

		    Crypto.mem_ctrl(Crypto.MEM_CHECK_ON);
		
		    if (mEnvironmentVariables.GetValueOrDefault("OPENSSL_FIPS") != default) {
		        BIO.printf(bio_err, "FIPS mode not supported.\n");
		        return 1;
		    }

			BIO.printf(bio_out, "App args:\n[\n");

			for (int i = 0; i < args.Count; i++) {
				BIO.printf(bio_out, "  %d - %s\n", i, args[i].CStr());
			}

			BIO.printf(bio_out, "]\n\n");
			
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
			return ret;
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
	}
}
