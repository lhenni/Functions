package edu.uhdts.dsl.functions.codegen.classgenerators

import edu.uhdts.dsl.functions.codegen.helper.ClassNamesGenerators.ClassNameGenerator
import edu.uhdts.dsl.functions.codegen.typesbuilder.TypesBuilderExtensionProvider
import edu.uhdts.dsl.functions.functionsLanguage.ExecuteStatement
import edu.uhdts.dsl.functions.functionsLanguage.Function
import edu.uhdts.dsl.functions.functionsLanguage.FunctionCallStatement
import edu.uhdts.dsl.functions.functionsLanguage.FunctionStatement
import java.util.HashMap
import org.eclipse.xtend2.lib.StringConcatenationClient
import org.eclipse.xtext.common.types.JvmConstructor
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmVisibility

import static edu.uhdts.dsl.functions.codegen.helper.FunctionsLanguageConstants.*

import static extension edu.uhdts.dsl.functions.codegen.helper.ClassNamesGenerators.*

class FunctionClassGenerator extends ClassGenerator {
	protected final Function function;
	var String generalUserExecutionClassQualifiedName;
	final ClassNameGenerator functionClassNameGenerator;
	var ClassNameGenerator functionsFacadeClassNameGenerator;
	extension var UserExecutionClassGenerator userExecutionClassGenerator;
	static val USER_EXECUTION_FIELD_NAME = "userExecution";
	var JvmGenericType generatedClass
	var JvmGenericType userExecutionClass

	public new(Function function, TypesBuilderExtensionProvider typesBuilderExtensionProvider) {
		super(typesBuilderExtensionProvider)
		this.function = function;
		this.functionClassNameGenerator = function.functionClassNameGenerator;
		this.functionsFacadeClassNameGenerator = function.functionsFile.functionsFacadeClassNameGenerator;
		this.generalUserExecutionClassQualifiedName = functionClassNameGenerator.qualifiedName + "." + USER_EXECUTION_SIMPLE_NAME;
		this.userExecutionClassGenerator = new UserExecutionClassGenerator(typesBuilderExtensionProvider, function, 
			functionClassNameGenerator.qualifiedName + "." + USER_EXECUTION_SIMPLE_NAME);
	}

	override JvmGenericType generateEmptyClass() {
		if (function === null) {
			return null;
		}

		userExecutionClass = userExecutionClassGenerator.generateEmptyClass()
		generatedClass = function.toClass(functionClassNameGenerator.qualifiedName) [
			visibility = JvmVisibility.PUBLIC
		]
	}

	override generateBody() {
		val executeMethod = generateMethodExecuteFunction()

		generatedClass => [
			members += function.toField(FUNCTIONS_FACADE_FIELD_NAME, typeRef(functionsFacadeClassNameGenerator.qualifiedName))
			members += function.toField(USER_EXECUTION_FIELD_NAME, typeRef(userExecutionClass))
			members += userExecutionClassGenerator.generateBody()
			members += function.generateConstructor()
			members += executeMethod
		]
	}

	protected def JvmConstructor generateConstructor(Function function) {
		return function.toConstructor [
			visibility = JvmVisibility.PUBLIC;
			body = '''
			this.«USER_EXECUTION_FIELD_NAME» = new «generalUserExecutionClassQualifiedName»();
			this.«FUNCTIONS_FACADE_FIELD_NAME» = new «functionsFacadeClassNameGenerator.qualifiedName»();
			'''
		]
	}

	private def dispatch StringConcatenationClient createStatements(FunctionCallStatement functionCallStatement) {
		val callFunctionMethod = generateMethodCallFunction(functionCallStatement, typeRef(functionsFacadeClassNameGenerator.qualifiedName));
		return generateExecutionMethodCall(callFunctionMethod);
	}
	
	private def dispatch StringConcatenationClient createStatements(ExecuteStatement executeStatement) {
		val executeMethod = generateMethodExecute(executeStatement, typeRef(functionsFacadeClassNameGenerator.qualifiedName));
		return generateExecutionMethodCall(executeMethod);
	}
	
	private def StringConcatenationClient generateExecutionMethodCall(JvmOperation executionMethod) {
		val StringConcatenationClient methodCall = '''«USER_EXECUTION_FIELD_NAME».«executionMethod.simpleName»(«FUNCTIONS_FACADE_FIELD_NAME»);''';
		return methodCall;
	}

	protected def generateMethodExecuteFunction() {
		val methodName = "executeFunction";
		val functionStatements = function.statements;
		val functionStatementsMap = new HashMap<FunctionStatement, StringConcatenationClient>();
		for (FunctionStatement functionStatement : functionStatements) {
			functionStatementsMap.put(functionStatement, createStatements(functionStatement));
		}
		return generateUnassociatedMethod(methodName, typeRef(Boolean.TYPE)) [
			visibility = JvmVisibility.PUBLIC; // CHANGED
			body = '''
				System.out.println("Debug: Called function «functionClassNameGenerator.simpleName»:");
				
				«FOR functionStatement : functionStatements»
					«functionStatementsMap.get(functionStatement)»
				«ENDFOR»
				
				return true;
			'''
		];
	}
}
