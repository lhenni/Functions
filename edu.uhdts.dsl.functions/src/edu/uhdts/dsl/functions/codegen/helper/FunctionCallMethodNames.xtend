package edu.uhdts.dsl.functions.codegen.helper

import edu.uhdts.dsl.functions.functionsLanguage.Function
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsImport

import static edu.uhdts.dsl.functions.codegen.helper.FunctionsLanguageConstants.*

final class FunctionCallMethodNames {

	private new() {
	}

	public static def String getCallMethodName(Function function) {
		return function.name;
	}
	
	public static def String getImportedCallMethodName(FunctionsImport functionsImport, Function function) {
		if(functionsImport.prefix === null) return getCallMethodName(function);
		return functionsImport.prefix + IMPORTED_FUNCTION_PREFIX_SEPARATOR + getCallMethodName(function);
	}
}
