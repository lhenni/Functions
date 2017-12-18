package edu.uhdts.dsl.functions.codegen.helper

import edu.uhdts.dsl.functions.helper.XtendImportHelper
import edu.uhdts.dsl.functions.functionsLanguage.Function
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsSegment

final class ClassNamesGenerators {
	public static val FSA_SEPARATOR = "/";
	private static String BASIC_PACKAGE = "mir";
	private static val XTEND_FILE_EXTENSION = ".java";
	private static String FUNCTIONS_PACKAGE = "functions";
	private static String ROUTINES_FACADE_CLASS_NAME = "FunctionsFacade";

	private new() {
	}

	static def generateClass(CharSequence classImplementation, String packageName, XtendImportHelper importHelper) '''
		package «packageName»;
		
		«importHelper.generateImportCode»
		
		«classImplementation»
	'''

	public static def String getFilePath(String qualifiedClassName) '''
	«qualifiedClassName.replace('.', FSA_SEPARATOR)»«XTEND_FILE_EXTENSION»'''

	public static def String getBasicMirPackageQualifiedName() '''
	«BASIC_PACKAGE»'''

	public static def String getBasicFunctionsPackageQualifiedName() '''
	«basicMirPackageQualifiedName».«edu.uhdts.dsl.functions.codegen.helper.ClassNamesGenerators.FUNCTIONS_PACKAGE»'''

	private static def String correctAcronymCapitalization(String potentialAcronym) {
		if (potentialAcronym.toUpperCase == potentialAcronym) {
			return potentialAcronym.toLowerCase.toFirstUpper;
		}
		return potentialAcronym;
	}

	private static def String getPackageName(FunctionsSegment functionsSegment) '''
	functions'''

	private static def String getQualifiedPackageName(FunctionsSegment functionsSegment) '''
	«basicFunctionsPackageQualifiedName».«functionsSegment.packageName»'''

	public static def ClassNameGenerator getExecutorClassNameGenerator(FunctionsSegment functionsSegment) {
		return new ExecutorClassNameGenerator(functionsSegment);
	}

	public static def ClassNameGenerator getFunctionsFacadeClassNameGenerator(FunctionsSegment functionsSegment) {
		return new FunctionsFacadeClassNameGenerator(functionsSegment);
	}

	public static def ClassNameGenerator getFunctionClassNameGenerator(Function function) {
		return new FunctionClassNameGenerator(function);
	}

	public static abstract class ClassNameGenerator {
		public def String getQualifiedName() '''
		«packageName».«simpleName»'''

		public def String getSimpleName();

		public def String getPackageName();
	}

	private static class ExecutorClassNameGenerator extends ClassNameGenerator {
		private val FunctionsSegment functionsSegment;

		public new(FunctionsSegment functionsSegment) {
			this.functionsSegment = functionsSegment;
		}

		public override getSimpleName() '''
		Executor'''

		public override getPackageName() '''
		«functionsSegment.qualifiedPackageName».«functionsSegment.name.toFirstLower»'''
	}

	private static class FunctionClassNameGenerator extends ClassNameGenerator {
		protected val Function function;

		public new(Function function) {
			this.function = function;
		}

		public override String getSimpleName() '''
		«function.name.toFirstUpper»Function'''

		public override String getPackageName() '''
		«basicFunctionsPackageQualifiedName».«function.functionsSegment.name.toFirstLower»'''
	}

	private static class FunctionsFacadeClassNameGenerator extends ClassNameGenerator {
		private val FunctionsSegment functionsSegment;

		public new(FunctionsSegment functionsSegment) {
			this.functionsSegment = functionsSegment;
		}

		public override String getSimpleName() '''
		«ROUTINES_FACADE_CLASS_NAME»'''

		public override String getPackageName() '''
		«basicFunctionsPackageQualifiedName».«functionsSegment.name.toFirstLower»'''
	}
}
