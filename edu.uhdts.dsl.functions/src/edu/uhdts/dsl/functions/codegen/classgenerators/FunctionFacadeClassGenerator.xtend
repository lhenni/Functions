package edu.uhdts.dsl.functions.codegen.classgenerators

import com.google.common.base.Predicate
import edu.uhdts.dsl.functions.codegen.helper.ClassNamesGenerators.ClassNameGenerator
import edu.uhdts.dsl.functions.codegen.typesbuilder.TypesBuilderExtensionProvider
import edu.uhdts.dsl.functions.functionsLanguage.Function
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsFile
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsImport
import java.util.HashSet
import org.eclipse.emf.common.util.ECollections
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmVisibility

import static extension edu.uhdts.dsl.functions.codegen.helper.ClassNamesGenerators.*

class FunctionFacadeClassGenerator extends ClassGenerator {
	val FunctionsFile functionsFile
	val ClassNameGenerator functionsFacadeNameGenerator;
	var JvmGenericType generatedClass

	new(FunctionsFile functionsFile, TypesBuilderExtensionProvider typesBuilderExtensionProvider) {
		super(typesBuilderExtensionProvider);
		this.functionsFile = functionsFile
		this.functionsFacadeNameGenerator = functionsFile.functionsFacadeClassNameGenerator
	}

	public override generateEmptyClass() {
		generatedClass = functionsFile.toClass(functionsFacadeNameGenerator.qualifiedName)[]
	}

	override generateBody() {
		val duplicateFunctionNamesFilter = new Predicate<String>() {
			val functionMethodNames = new HashSet<String>();

			override apply(String functionName) {
				if (functionMethodNames.contains(functionName)) {
					return false;
				} else {
					// keep track of function method names which passed the filter:
					functionMethodNames.add(functionName);
					return true;
				}
			}
		};
		generatedClass => [
			members += functionsFile.toConstructor() [
				body = '''super();'''
			]
			members += functionsFile.functions.filter[duplicateFunctionNamesFilter.apply(getCallMethodName(it))].map [
				generateCallMethod
			];
			members += functionsFile.functionImports.map[generateImportedCallMethods(it, duplicateFunctionNamesFilter)].
				flatten;
		]
	}

	private def String getCallMethodName(Function function) {
		return function.name;
	}

	private def JvmOperation generateCallMethod(Function function) {
		return generateCallMethod(function, getCallMethodName(function));
	}

	private def String getImportedCallMethodName(FunctionsImport functionsImport, Function function) {
		if(functionsImport.prefix === null) return getCallMethodName(function);
		return functionsImport.prefix + "_" + getCallMethodName(function);
	}

	private def JvmOperation generateImportedCallMethod(FunctionsImport functionsImport, Function function) {
		return generateCallMethod(function, getImportedCallMethodName(functionsImport, function));
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

	private def EList<Function> getImportedFunctions(FunctionsImport functionsImport) {
		if(functionsImport === null) return ECollections.emptyEList;
		val includedFunctionsFile = functionsImport.functionsFile;
		if(includedFunctionsFile === null) return ECollections.emptyEList;
		// System.out.println("DEBUG: includedFunctionsFile: " + includedFunctionsFile);
		// System.out.println("DEBUG: includedFunctionsFile name: " + includedFunctionsFile.name);
		// System.out.println("DEBUG: includedFunctionsFile functions: " + includedFunctionsFile.functions);
		return includedFunctionsFile.functions;
	}

	private def Iterable<JvmOperation> generateImportedCallMethods(FunctionsImport functionsImport,
		Predicate<String> functionNameFilter) {
		return getImportedFunctions(functionsImport).filter [
			functionNameFilter.apply(getImportedCallMethodName(functionsImport, it))
		].map[generateImportedCallMethod(functionsImport, it)];
	}
}
