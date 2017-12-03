package edu.uhdts.dsl.functions.scoping

import com.google.inject.Inject
import com.google.inject.Singleton
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsLanguagePackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.IResourceDescriptions
import org.eclipse.xtext.scoping.impl.SimpleScope

@Singleton
class FunctionsFileScopeHelper {

	@Inject IContainer.Manager manager
	@Inject IResourceDescriptions index

	def createScope(Resource resource, boolean includeLocalFunctionsFiles) {
		val visibleFunctionsFiles = getVisibleFunctionsFileDescriptions(resource, includeLocalFunctionsFiles);
		return new SimpleScope(visibleFunctionsFiles);
	}

	private def Iterable<IEObjectDescription> getVisibleFunctionsFileDescriptions(Resource resource,
		boolean includeLocalFunctionsFiles) {
		val resourceDesc = index.getResourceDescription(resource.URI)
		return manager.getVisibleContainers(resourceDesc, index).map[resourceDescriptions].flatten.filter [
			includeLocalFunctionsFiles || !it.equals(resourceDesc)
		].map [
			getExportedObjectsByType(FunctionsLanguagePackage.eINSTANCE.getFunctionsFile)
		].flatten;
	}
}
