using System;
using Beef_OpenSSL_Test.Functions;

namespace Beef_OpenSSL_Test
{
	public struct options_st
	{
	    public String name;
	    public int retval;
	    /*
	     * value type: - no value (also the value zero), n number, p positive number, u unsigned, l long, s string, < input file, > output file,
	     * f any format, F der/pem format, E der/pem/engine format identifier.
	     * l, n and u include zero; p does not.
	     */
	    public char8 valtype;
	    public String helpstr;

		public this(String name, int retval, char8 valtype, String helpstr)
		{
			this.name = name;
			this.retval = retval;
			this.valtype = valtype;
			this.helpstr = helpstr;
		}
	}
	public typealias OPTIONS = options_st;

	public enum FUNC_TYPE
	{
	    FT_none,
		FT_general,
		FT_md,
		FT_cipher,
		FT_pkey,
	    FT_md_alg,
		FT_cipher_alg
	}
	
	public struct function_st
	{
	    public FUNC_TYPE type;
	    public String name;
	    public function int(String[] args) func;
	    public OPTIONS* help;

		public this()
		{
			this.type = .FT_none;
			this.name = default;
			this.func = default;
			this.help = default;
		}

		public this(FUNC_TYPE type, String name, function int(String[] args) func, OPTIONS* help)
		{
			this.type = type;
			this.name = name;
			this.func = func;
			this.help = help;
		}
	}
	public typealias FUNCTION = function_st;
	public struct lhash_st_FUNCTION {}

	static {
		public static FUNCTION[?] functions = .(
			.(.FT_general, "help", => Program.help_main, &Program.help_options[0]),
			.(.FT_general, "test", => TestFunc.Main, &TestFunc.Options[0]),
			.(0, null, null, null)
		);
	}
}
