package edu.uhdts.dsl.functions.scoping

import com.google.common.base.Predicate
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.common.types.xtext.TypesAwareDefaultGlobalScopeProvider
import org.eclipse.xtext.resource.IEObjectDescription

class FunctionsLanguageGlobalScopeProvider extends TypesAwareDefaultGlobalScopeProvider {

	override getScope(Resource resource, EReference ref, Predicate<IEObjectDescription> filter) {
		return super.getScope(resource, ref, filter);
	}
}
