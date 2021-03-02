using System;

namespace Beef_OpenSSL
{
	sealed abstract class AppLink
	{
        [CLink]
        extern static void AppLink_setStdin(function void*() func);
        [CLink]
        extern static void AppLink_setStdout(function void*() func);
        [CLink]
        extern static void AppLink_setStderr(function void*() func);
        [CLink]
        extern static void AppLink_setFeof(function int(Platform.BfpFile* fp) func);
        [CLink]
        extern static void AppLink_setFerror(function int(Platform.BfpFile* fp) func);
        [CLink]
        extern static void AppLink_setClearerr(function int(Platform.BfpFile* fp) func);
        [CLink]
        extern static void AppLink_setFileno(function int(Platform.BfpFile* fp) func);
        [CLink]
        extern static void AppLink_setFsetmod(function int(Platform.BfpFile* fp, char8 mod) func);
        [CLink]
        extern static void** AppLink_getALArray();

        const int APPLINK_MAX = 22;

		static bool once = true;

		static Platform.BfpFile* STDIN = null;
		static Platform.BfpFile* STDOUT = null;
		static Platform.BfpFile* STDERR = null;

		[Export, CLink]
		public static void** OPENSSL_Applink()
		{
			if (once) {
                AppLink_setStdin(=> app_stdin);
                AppLink_setStdout(=> app_stdout);
                AppLink_setStderr(=> app_stderr);
                AppLink_setFeof(=> app_feof);
                AppLink_setFileno(=> app_fileno);

				once = false;
            }

			return AppLink_getALArray();
        }

		[AlwaysInclude]
		public static void* app_stdin()
		{
			Platform.BfpFileResult result = .Ok;

            if (STDIN == null)
			    STDIN = Platform.BfpFile_GetStd(.In, &result);

			return STDIN;
		}

		[AlwaysInclude]
		public static void* app_stdout()
		{
			Platform.BfpFileResult result = .Ok;

            if (STDOUT == null)
			    STDOUT = Platform.BfpFile_GetStd(.Out, &result);

			return STDOUT;
		}

		[AlwaysInclude]
		public static void* app_stderr()
		{
			Platform.BfpFileResult result = .Ok;

            if (STDERR == null)
			    STDERR = Platform.BfpFile_GetStd(.Error, &result);

			return STDERR;
		}

		[AlwaysInclude]
		public static int app_feof(Platform.BfpFile* fp)
		{
			int ch;
			Platform.BfpFileResult fres = .Ok;
			int len = Platform.BfpFile_Read(fp, &ch, sizeof(char8), -1, &fres); /* Read one byte to check feof()'s flag */

			if ((len > 0) && ((fres == .Ok) || (fres == .PartialData)))
				Platform.BfpFile_Seek(fp, -sizeof(char8), .Relative); /* push byte back onto stream if valid. */

			return (fres.Underlying > 0) ? 1 : 0;
		}

		[AlwaysInclude]
		public static int app_fileno(Platform.BfpFile* fp)
		{
			if (fp == STDIN)
				return 0;
			if (fp == STDOUT)
				return 1;
			if (fp == STDERR)
				return 2;

			return -1;
		}
    }
}
