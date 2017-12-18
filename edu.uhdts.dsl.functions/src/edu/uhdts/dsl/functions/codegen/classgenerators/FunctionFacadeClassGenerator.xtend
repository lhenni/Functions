package edu.uhdts.dsl.functions.codegen.classgenerators

import edu.uhdts.dsl.functions.codegen.helper.ClassNamesGenerators.ClassNameGenerator
import edu.uhdts.dsl.functions.codegen.typesbuilder.TypesBuilderExtensionProvider
import edu.uhdts.dsl.functions.functionsLanguage.Function
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsSegment
import java.util.LinkedHashMap
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmVisibility

import static extension edu.uhdts.dsl.functions.codegen.helper.ClassNamesGenerators.*
import static extension edu.uhdts.dsl.functions.codegen.helper.FunctionCallMethodNames.*

class FunctionFacadeClassGenerator extends ClassGenerator {
	val FunctionsSegment functionsSegment
	val ClassNameGenerator functionsFacadeNameGenerator;
	var JvmGenericType generatedClass

	new(FunctionsSegment functionsSegment, TypesBuilderExtensionProvider typesBuilderExtensionProvider) {
		super(typesBuilderExtensionProvider);
		this.functionsSegment = functionsSegment
		this.functionsFacadeNameGenerator = functionsSegment.functionsFacadeClassNameGenerator
	}

	public override generateEmptyClass() {
		generatedClass = functionsSegment.toClass(functionsFacadeNameGenerator.qualifiedName)[]
	}

	override generateBody() {
		val functionsByMethodNames = new LinkedHashMap<String, Function>();

		// functions:
		for (function : functionsSegment.functions) {
			functionsByMethodNames.put(function.callMethodName, function);
		}

		// imported functions:
		for (functionsImport : functionsSegment.functionsFile.functionsImports) {
			for (function : functionsImport.functionsSegment.functions) {
				functionsByMethodNames.putIfAbsent(functionsImport.getImportedCallMethodName(function), function)
			}
		}

		generatedClass => [
			members += functionsSegment.toConstructor() [
				body = '''super();'''
			]
			members += functionsByMethodNames.entrySet.map[generateCallMethod(it.value, it.key)];
		]
	}

	private def JvmOperation generateCallMethod(Function function, String methodName) {
		val functionNameGenerator = function.functionClassNameGenerator;
		function.associatePrimary(function.toMethod(methodName, typeRef(Boolean.TYPE)) [
			visibility = JvmVisibility.PUBLIC;
			body = '''
				«functionNameGenerator.qualifiedName» calledFunction = new «functionNameGenerator.qualifiedName»();
				return calledFunction.executeFunction();
			'''
		])
	}
}
