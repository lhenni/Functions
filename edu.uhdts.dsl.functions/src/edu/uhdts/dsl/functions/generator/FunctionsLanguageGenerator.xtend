package edu.uhdts.dsl.functions.generator

import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * This generator is called by Xtext when compiling Functions language
 * resources. When it’s called, functions will already have been translated
 * to their JVM types. So this generator only handles any remaining tasks.
 */
class FunctionsLanguageGenerator extends AbstractGenerator {

	@Inject IGenerator functionGenerator

	override doGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
		// functions
		functionGenerator.doGenerate(input, fsa)
	}
}
