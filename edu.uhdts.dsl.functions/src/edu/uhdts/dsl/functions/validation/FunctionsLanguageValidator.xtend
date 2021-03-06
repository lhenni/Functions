/*
 * generated by Xtext 2.12.0
 */
package edu.uhdts.dsl.functions.validation

import com.google.inject.Inject
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsLanguagePackage
import java.util.HashMap
import org.eclipse.xtext.validation.Check

import static edu.uhdts.dsl.functions.codegen.helper.FunctionsLanguageConstants.*
import edu.uhdts.dsl.functions.functionsLanguage.Function
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsSegment
import edu.uhdts.dsl.functions.scoping.FunctionsImportScopeHelper
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsFile
import static extension edu.uhdts.dsl.functions.codegen.helper.FunctionCallMethodNames.*
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsImport

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class FunctionsLanguageValidator extends AbstractFunctionsLanguageValidator {

	@Inject FunctionsImportScopeHelper functionsImportScopeHelper

	@Check
	def checkFunctionsFile(FunctionsFile functionsFile) {
		// detect duplicate functions imports:
		val alreadyCheckedFunctionsImports = new HashMap<String, FunctionsImport>();
		for (functionsImport : functionsFile.functionsImports) {
			val importedSegmentName = functionsImport.functionsSegment.name;
			if (alreadyCheckedFunctionsImports.containsKey(importedSegmentName)) {
				val errorMessage = "Duplicate functions import: " + importedSegmentName;
				error(errorMessage, functionsImport,
					FunctionsLanguagePackage.Literals.FUNCTIONS_IMPORT__FUNCTIONS_SEGMENT);
				val duplicateFunctionsImport = alreadyCheckedFunctionsImports.get(importedSegmentName);
				error(errorMessage, duplicateFunctionsImport,
					FunctionsLanguagePackage.Literals.FUNCTIONS_IMPORT__FUNCTIONS_SEGMENT);
			}
			alreadyCheckedFunctionsImports.put(importedSegmentName, functionsImport);
		}

		// detect duplicate functions segment names in same file:
		val alreadyCheckedSegments = new HashMap<String, FunctionsSegment>();
		for (functionsSegment : functionsFile.functionsSegments) {
			val functionsSegmentName = functionsSegment.name;
			if (alreadyCheckedSegments.containsKey(functionsSegmentName)) {
				val errorMessage = "Duplicate functions segment name: " + functionsSegmentName;
				error(errorMessage, functionsSegment, FunctionsLanguagePackage.Literals.FUNCTIONS_SEGMENT__NAME);
				val duplicateNameSegment = alreadyCheckedSegments.get(functionsSegmentName);
				error(errorMessage, duplicateNameSegment, FunctionsLanguagePackage.Literals.FUNCTIONS_SEGMENT__NAME);
			}
			alreadyCheckedSegments.put(functionsSegmentName, functionsSegment);
		}

		// detect duplicate functions segment names globally:
		val visibleFunctionsSegments = functionsImportScopeHelper.getVisibleFunctionsSegmentDescriptions(functionsFile.eResource, false);
		for (functionsSegment : functionsFile.functionsSegments) {
			val functionsSegmentName = functionsSegment.name;
			val otherFunctionsSegment = visibleFunctionsSegments.findFirst[name.toString.equals(functionsSegmentName)];
			if (otherFunctionsSegment !== null) {
				// path relative to current file:
				val path = otherFunctionsSegment.EObjectURI.trimFragment.deresolve(functionsSegment.eResource.URI);
				warning(
					"Duplicate functions segment name '" + functionsSegmentName + "': Already defined in " + path,
					functionsSegment,
					FunctionsLanguagePackage.Literals.FUNCTIONS_SEGMENT__NAME
				);
			}
		}
	}

	@Check
	def checkFunctionsSegment(FunctionsSegment functionsSegment) {
		// detect duplicate function names in same segment:
		val alreadyCheckedFunctions = new HashMap<String, Function>();
		for (function : functionsSegment.functions) {
			val functionName = function.callMethodName;
			if (alreadyCheckedFunctions.containsKey(functionName)) {
				val errorMessage = "Duplicate function name: " + functionName;
				error(errorMessage, function, FunctionsLanguagePackage.Literals.FUNCTION__NAME);
				val duplicateNameFunction = alreadyCheckedFunctions.get(functionName);
				error(errorMessage, duplicateNameFunction, FunctionsLanguagePackage.Literals.FUNCTION__NAME);
			}
			alreadyCheckedFunctions.put(functionName, function);
		}

		// detect duplicate function names across imports:
		val alreadyCheckedImportedFunctions = new HashMap<String, Function>();
		for (functionsImport : functionsSegment.functionsFile.functionsImports) {
			val importedFunctionsSegment = functionsImport.functionsSegment;
			for (function : importedFunctionsSegment.functions) {
				val functionName = functionsImport.getImportedCallMethodName(function);
				// name clashes with local functions:
				if (alreadyCheckedFunctions.containsKey(functionName)) {
					val duplicateNameFunction = alreadyCheckedFunctions.get(functionName);
					warning(
						"Duplicate function name '" + functionName + "': Hides an imported function from " + importedFunctionsSegment.name,
						duplicateNameFunction,
						FunctionsLanguagePackage.Literals.FUNCTION__NAME
					);
				}

				// name clashes between imports:
				if (alreadyCheckedImportedFunctions.containsKey(functionName)) {
					val duplicateNameFunction = alreadyCheckedImportedFunctions.get(functionName);
					warning(
						"Contains ambiguous function name '" + functionName + "': Already defined in " + duplicateNameFunction.functionsSegment.name,
						functionsImport,
						FunctionsLanguagePackage.Literals.FUNCTIONS_IMPORT__FUNCTIONS_SEGMENT
					);
				}
				alreadyCheckedImportedFunctions.put(functionName, function);
			}
		}
	}

	@Check
	def checkFunction(Function function) {
		if (!Character.isLowerCase(function.name.charAt(0))) {
			warning("Function names should start lower case", FunctionsLanguagePackage.Literals.FUNCTION__NAME);
		}
		if (function.name.contains(IMPORTED_FUNCTION_PREFIX_SEPARATOR)) {
			warning("Function names should not contain " + IMPORTED_FUNCTION_PREFIX_SEPARATOR,
				FunctionsLanguagePackage.Literals.FUNCTION__NAME);
		}
	}

//	public static val INVALID_NAME = 'invalidName'
//
//	@Check
//	def checkGreetingStartsWithCapital(Greeting greeting) {
//		if (!Character.isUpperCase(greeting.name.charAt(0))) {
//			warning('Name should start with a capital', 
//					FunctionsLanguagePackage.Literals.GREETING__NAME,
//					INVALID_NAME)
//		}
//	}
}
