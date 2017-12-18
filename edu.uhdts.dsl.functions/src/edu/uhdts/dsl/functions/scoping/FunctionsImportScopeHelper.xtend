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
class FunctionsImportScopeHelper {

	@Inject IContainer.Manager manager
	@Inject IResourceDescriptions index

	def createScope(Resource resource) {
		val visibleFunctionsSegments = getVisibleFunctionsSegmentDescriptions(resource, false);
		return new SimpleScope(visibleFunctionsSegments);
	}

	def Iterable<IEObjectDescription> getVisibleFunctionsSegmentDescriptions(Resource resource,
		boolean includeLocalFunctionsSegments) {
		val resourceDesc = index.getResourceDescription(resource.URI)
		val visibleContainers = manager.getVisibleContainers(resourceDesc, index);
		val visibleResourceDescriptions = visibleContainers.map[resourceDescriptions].flatten;
		val filteredResourceDescriptions = visibleResourceDescriptions.filter [
			includeLocalFunctionsSegments || !it.equals(resourceDesc)
		];
		val visibleFunctionsSegments = filteredResourceDescriptions.map [
			getExportedObjectsByType(FunctionsLanguagePackage.eINSTANCE.functionsSegment)
		].flatten;
		return visibleFunctionsSegments
	}
}
