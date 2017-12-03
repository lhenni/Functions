package edu.uhdts.dsl.functions.scoping

import com.google.common.base.Predicate
import com.google.inject.Inject
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsLanguagePackage
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.common.types.xtext.TypesAwareDefaultGlobalScopeProvider
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.IResourceDescriptions
import org.eclipse.xtext.scoping.Scopes

class FunctionsLanguageGlobalScopeProvider extends TypesAwareDefaultGlobalScopeProvider {

	override getScope(Resource resource, EReference ref, Predicate<IEObjectDescription> filter) {
		/*System.out.println("DEBUG scope start: " + resource + " , " + ref);
		if (ref.equals(FunctionsLanguagePackage.Literals.INCLUDE__FUNCTIONS_FILE)) {
			// TODO this might not actually be needed,
			// because DefaultGlobalScopeProvider already allows referencing external objects from visible containers
			val visibleFunctionsFiles = getVisibleFunctionsFiles(resource);
			// TODO implement IScope instead of resolving all potential FunctionsFiles
			val scope = Scopes.scopeFor(visibleFunctionsFiles);
			System.out.println("DEBUG scope result: " + scope.allElements);
			return scope;
		}*/
		return super.getScope(resource, ref, filter);
	}

	/*@Inject IContainer.Manager manager
	@Inject IResourceDescriptions index

	def List<EObject> getVisibleFunctionsFiles(Resource resource) {
		val functionsFiles = new ArrayList<EObject>();
		val resourceDesc = index.getResourceDescription(resource.URI)
		for (visibleContainer : manager.getVisibleContainers(resourceDesc, index)) {
			for (visibleResourceDesc : visibleContainer.resourceDescriptions) {
				// skip objects from the same resource:
				if (!visibleResourceDesc.equals(resourceDesc)) {
					for (visibleObjectDesc : visibleResourceDesc.getExportedObjectsByType(
						FunctionsLanguagePackage.eINSTANCE.getFunctionsFile)) {
						System.out.println("DEBUG scope: " + visibleObjectDesc);
						val functionsFile = visibleObjectDesc.EObjectOrProxy;
						if (functionsFile.eIsProxy) {
							// attempt to resolve this proxy by loading the resource:
							val resolvedFunctionsFile = EcoreUtil2.resolve(functionsFile, resource.resourceSet);
							if (resolvedFunctionsFile.eIsProxy) {
								System.out.println("DEBUG scope, could not resolve: " + resolvedFunctionsFile);
							} else {
								System.out.println("DEBUG scope, resolved: " + resolvedFunctionsFile);
								functionsFiles.add(resolvedFunctionsFile);
							}
						}
					}
				}
			}
		}
		// debug:
		System.out.println("DEBUG scope, found+resolved: " + functionsFiles);
		return functionsFiles;
	}*/
}
