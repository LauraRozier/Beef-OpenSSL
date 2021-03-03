using System;

namespace Beef_OpenSSL_Test
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
        extern static void AppLink_setFprintf(function char8*(Platform.BfpFile* fp, char8* fmt, ...) func);
		[CLink]
        extern static void AppLink_setFgets(function char8*(char8* buff, int maxCount, Platform.BfpFile* fp) func);
		[CLink] /* !!REQUIRED!! */
        extern static void AppLink_setFread(function uint(void* buff, uint size, uint count, Platform.BfpFile* fp) func);
		[CLink] /* !!REQUIRED!! */
        extern static void AppLink_setFwrite(function uint(void* buff, uint size, uint count, Platform.BfpFile* fp) func);
        [CLink]
        extern static void AppLink_setFsetmod(function int(Platform.BfpFile* fp, char8 mod) func);
        [CLink]
        extern static void AppLink_setFeof(function int(Platform.BfpFile* fp) func);
        [CLink] /* should not be used */
        extern static void AppLink_setFclose(function int(Platform.BfpFile* fp) func);

		[CLink] /* solely for completeness */
        extern static void AppLink_setFopen(function Platform.BfpFile*(char8* filename, char8* mod) func);
		[CLink]
        extern static void AppLink_setFseek(function int(Platform.BfpFile* fp, int32 offset, int origin) func);
		[CLink]
        extern static void AppLink_setFtellr(function int32(Platform.BfpFile* fp) func);
		[CLink]
        extern static void AppLink_setFflush(function int(Platform.BfpFile* fp) func);
        [CLink]
        extern static void AppLink_setFerror(function int(Platform.BfpFile* fp) func);
        [CLink]
        extern static void AppLink_setClearerr(function int(Platform.BfpFile* fp) func);
        [CLink] /* to be used with below */
        extern static void AppLink_setFileno(function int(Platform.BfpFile* fp) func);

		[CLink] /* formally can't be used, as flags can vary */
        extern static void AppLink_set_open(function char8*(char8* filename, int openFlags, ...) func);
		[CLink]
        extern static void AppLink_set_read(function int(int fh, void* dstBuff, uint maxCharCount) func);
		[CLink]
        extern static void AppLink_set_write(function int(int fh, void* buff, uint maxCharCount) func);
		[CLink]
        extern static void AppLink_set_lseek(function int32(int fh, int32 offset, int origin) func);
		[CLink]
        extern static void AppLink_set_close(function int(int fh) func);

        [CLink]
        extern static void** AppLink_getALArray();

		static bool isInitialized = false;

		[Export, CLink]
		public static void** OPENSSL_Applink()
		{
			if (!isInitialized) {
				//AppLink_setStdin(function void*() func);
				//AppLink_setStdout(function void*() func);
				//AppLink_setStderr(function void*() func);
				//AppLink_setFprintf(function char8*(Platform.BfpFile* fp, char8* fmt, ...) func);
				//AppLink_setFgets(function char8*(char8* buff, int maxCount, Platform.BfpFile* fp) func);
				AppLink_setFread(=> app_fread); /* !!REQUIRED!! */
				AppLink_setFwrite(=> app_fwrite); /* !!REQUIRED!! */
				//AppLink_setFsetmod(function int(Platform.BfpFile* fp, char8 mod) func);
				//AppLink_setFeof(function int(Platform.BfpFile* fp) func);
				//AppLink_setFclose(function int(Platform.BfpFile* fp) func);

				//AppLink_setFopen(function Platform.BfpFile*(char8* filename, char8* mod) func);
				//AppLink_setFseek(function int(Platform.BfpFile* fp, int32 offset, int origin) func);
				//AppLink_setFtellr(function int32(Platform.BfpFile* fp) func);
				//AppLink_setFflush(function int(Platform.BfpFile* fp) func);
				//AppLink_setFerror(function int(Platform.BfpFile* fp) func);
				//AppLink_setClearerr(function int(Platform.BfpFile* fp) func);
				//AppLink_setFileno(function int(Platform.BfpFile* fp) func);

		        //AppLink_set_open(function char8*(char8* filename, int openFlags, ...) func);
		        //AppLink_set_read(function int(int fh, void* dstBuff, uint maxCharCount) func);
		        //AppLink_set_write(function int(int fh, void* buff, uint maxCharCount) func);
		        //AppLink_set_lseek(function int32(int fh, int32 offset, int origin) func);
		        //AppLink_set_close(function int(int fh) func);

				isInitialized = true;
            }

			return AppLink_getALArray();
        }

		/*
		static Platform.BfpFile* STDIN = null;
		static void* app_stdin()
		{
			Platform.BfpFileResult result = .Ok;

            if (STDIN == null)
			    STDIN = Platform.BfpFile_GetStd(.In, &result);

			return STDIN;
		}
		*/
		
		/*
		static Platform.BfpFile* STDOUT = null;
		static void* app_stdout()
		{
			Platform.BfpFileResult result = .Ok;

            if (STDOUT == null)
			    STDOUT = Platform.BfpFile_GetStd(.Out, &result);

			return STDOUT;
		}
		*/
			
		/*
		static Platform.BfpFile* STDERR = null;
		static void* app_stderr()
		{
			Platform.BfpFileResult result = .Ok;

            if (STDERR == null)
			    STDERR = Platform.BfpFile_GetStd(.Error, &result);

			return STDERR;
		}
		*/
		
		[AlwaysInclude] /* !!REQUIRED!! */
		static uint app_fread(void* buff, uint size, uint count, Platform.BfpFile* fp)
		{
			Platform.BfpFileResult result = .Ok;
			int numBytesRead = Platform.BfpFile_Read(fp, buff, (int)(size * count), -1, &result);

			if ((result != .Ok) && (result != .PartialData))
				return 0;

			return (uint)numBytesRead;
		}

		[AlwaysInclude] /* !!REQUIRED!! */
		static uint app_fwrite(void* buff, uint size, uint count, Platform.BfpFile* fp)
		{
			Platform.BfpFileResult result = .Ok;
			int numBytesWritten = Platform.BfpFile_Write(fp, buff, (int)(size * count), -1, &result);

			if ((result != .Ok) && (result != .PartialData))
				return 0;

			return (uint)numBytesWritten;
		}

		/*
		static int app_feof(Platform.BfpFile* fp)
		{
			int ch;
			Platform.BfpFileResult fres = .Ok;
			int len = Platform.BfpFile_Read(fp, &ch, sizeof(char8), -1, &fres); /* Read one byte to check feof()'s flag */

			if ((len > 0) && ((fres == .Ok) || (fres == .PartialData)))
				Platform.BfpFile_Seek(fp, -sizeof(char8), .Relative); /* push byte back onto stream if valid. */

			return (fres.Underlying > 0) ? 1 : 0;
		}
		*/
		
		/*
		static int app_fileno(Platform.BfpFile* fp)
		{
			if (fp == STDIN)
				return 0;
			if (fp == STDOUT)
				return 1;
			if (fp == STDERR)
				return 2;

			return -1;
		}
		*/
    }
}
