package edu.uhdts.dsl.functions.scoping

import com.google.inject.Inject
import edu.uhdts.dsl.functions.functionsLanguage.FunctionsLanguagePackage
import org.eclipse.emf.common.util.ECollections
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.xbase.scoping.XImportSectionNamespaceScopeProvider

class FunctionsLanguageScopeProviderDelegate extends XImportSectionNamespaceScopeProvider {

	@Inject FunctionsFileScopeHelper functionsFileScopeHelper

	override getScope(EObject context, EReference reference) {
		// context differs during content assist: 
		// * if no input is provided yet, the container is the context as the element is not known yet
		// * if some input is already provided, the element is the context
		if (reference.equals(FunctionsLanguagePackage.Literals.FUNCTIONS_IMPORT__FUNCTIONS_FILE)) {
			return functionsFileScopeHelper.createScope(context.eResource, false)

		// parent scopes forwards to DefaultGlobalScope which already includes all FunctionsFiles from visible resources
		// -> filter local FunctionsFiles from parent scope:
		/*val parent = super.getScope(context, reference);
		 * val localObjectUris = getContents(context.eResource).map[EcoreUtil2.getURI(it)]
		 * return new FilteringScope(parent, new Predicate<IEObjectDescription>() {

		 * 	override apply(IEObjectDescription objectDesc) {
		 * 		return !localObjectUris.contains(objectDesc.EObjectURI)
		 * 	}
		 });*/
		}
		super.getScope(context, reference)
	}

	private def EList<EObject> getContents(Resource resource) {
		if(resource === null) return ECollections.emptyEList;
		return resource.contents
	}
}
