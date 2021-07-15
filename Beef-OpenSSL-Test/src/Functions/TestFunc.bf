using System;

namespace Beef_OpenSSL_Test.Functions
{
	class TestFunc
	{
		public enum OPTION_choice: int
		{
		    OPT_ERR = -1,
			OPT_EOF = 0,
			OPT_HELP,
		    OPT_INFORM,
			OPT_IN,
			OPT_OUT,
			OPT_INDENT,
			OPT_NOOUT,
		    OPT_OID,
			OPT_OFFSET,
			OPT_LENGTH,
			OPT_DUMP,
			OPT_DLIMIT,
		    OPT_STRPARSE,
			OPT_GENSTR,
			OPT_GENCONF,
			OPT_STRICTPEM,
		    OPT_ITEM
		}

		public static OPTIONS[?] Options = .(
		    .("help", OPTION_choice.OPT_HELP.Underlying, '-', "Display this summary"),
		    .("inform", OPTION_choice.OPT_INFORM.Underlying, 'F', "input format - one of DER PEM"),
		    .("in", OPTION_choice.OPT_IN.Underlying, '<', "input file"),
		    .("out", OPTION_choice.OPT_OUT.Underlying, '>', "output file (output format is always DER)"),
		    .("i", OPTION_choice.OPT_INDENT.Underlying, 0, "indents the output"),
		    .("noout", OPTION_choice.OPT_NOOUT.Underlying, 0, "do not produce any output"),
		    .("offset", OPTION_choice.OPT_OFFSET.Underlying, 'p', "offset into file"),
		    .("length", OPTION_choice.OPT_LENGTH.Underlying, 'p', "length of section in file"),
		    .("oid", OPTION_choice.OPT_OID.Underlying, '<', "file of extra oid definitions"),
		    .("dump", OPTION_choice.OPT_DUMP.Underlying, 0, "unknown data in hex form"),
		    .("dlimit", OPTION_choice.OPT_DLIMIT.Underlying, 'p', "dump the first arg bytes of unknown data in hex form"),
		    .("strparse", OPTION_choice.OPT_STRPARSE.Underlying, 'p', "offset; a series of these can be used to 'dig'"),
		    .(OsslOpt.MORE_STR, 0, 0, "into multiple ASN1 blob wrappings"),
		    .("genstr", OPTION_choice.OPT_GENSTR.Underlying, 's', "string to generate ASN1 structure from"),
		   	.("genconf", OPTION_choice.OPT_GENCONF.Underlying, 's', "file to generate ASN1 structure from"),
		    .(OsslOpt.MORE_STR, 0, 0, "(-inform  will be ignored)"),
		    .("strictpem", OPTION_choice.OPT_STRICTPEM.Underlying, 0, "do not attempt base64 decode outside PEM markers"),
		    .("item", OPTION_choice.OPT_ITEM.Underlying, 's', "item to parse and print"),
		    .(null, 0, 0, null)
		);

		public static int Main(String[] args)
		{
			return 0;
		}
	}
}
