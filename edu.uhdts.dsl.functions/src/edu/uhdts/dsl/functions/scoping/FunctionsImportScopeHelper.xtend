package edu.uhdts.dsl.functions.scoping

import com.google.inject.Inject
import com.google.inject.Singleton
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsLanguagePackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.scoping.impl.SimpleScope
import org.eclipse.xtext.resource.IResourceDescriptionsProvider

@Singleton
class FunctionsImportScopeHelper {

	@Inject IContainer.Manager containerManager
	@Inject IResourceDescriptionsProvider provider;

	def createScope(Resource resource) {
		val visibleFunctionsSegments = getVisibleFunctionsSegmentDescriptions(resource, false);
		return new SimpleScope(visibleFunctionsSegments);
	}

	def Iterable<IEObjectDescription> getVisibleFunctionsSegmentDescriptions(Resource resource, boolean includeLocalFunctionsSegments) {
		val resourceDescriptions = provider.getResourceDescriptions(resource.resourceSet);
		val resourceDesc = resourceDescriptions.getResourceDescription(resource.URI)
		val visibleContainers = containerManager.getVisibleContainers(resourceDesc, resourceDescriptions);
		val visibleResourceDescriptions = visibleContainers.map[it.resourceDescriptions].flatten;
		val filteredResourceDescriptions = visibleResourceDescriptions.filter [
			includeLocalFunctionsSegments || !it.equals(resourceDesc)
		];
		val visibleFunctionsSegments = filteredResourceDescriptions.map [
			getExportedObjectsByType(FunctionsLanguagePackage.eINSTANCE.functionsSegment)
		].flatten;
		return visibleFunctionsSegments
	}
}
