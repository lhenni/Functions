package edu.uhdts.dsl.functions.generator

import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import com.google.inject.Inject
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.IResourceDescriptions

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

		// TODO debugging:
		//printVisibleResources(input)
	}

	@Inject IContainer.Manager manager
	@Inject IResourceDescriptions index

	def void printVisibleResources(Resource resource) {
		val descr = index.getResourceDescription(resource.URI)
		for (visibleContainer : manager.getVisibleContainers(descr, index)) {
			println("Container: " + visibleContainer.toString)
			for (visibleResourceDesc : visibleContainer.resourceDescriptions) {
				println(visibleResourceDesc.URI)
				println("Exported objects: ")
				for (visibleResourceObjectDesc : visibleResourceDesc.exportedObjects) {
					println(
						visibleResourceObjectDesc.EObjectURI + "  name: " + visibleResourceObjectDesc.name +
							"   class: " + visibleResourceObjectDesc.EClass)
				}
				println("-----")
			}
		}
	}
}
