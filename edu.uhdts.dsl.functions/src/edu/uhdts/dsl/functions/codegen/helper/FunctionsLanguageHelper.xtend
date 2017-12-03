package edu.uhdts.dsl.functions.codegen.helper

import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.XBlockExpression
import edu.uhdts.dsl.functions.generator.SimpleTextXBlockExpression
import org.eclipse.emf.ecore.resource.Resource
import static com.google.common.base.Preconditions.*
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClassifier

final class FunctionsLanguageHelper {
	private new() {
	}

	public static def dispatch String getXBlockExpressionText(XExpression expression) '''
	{
		«NodeModelUtils.getNode(expression).text»
	}'''

	public static def dispatch String getXBlockExpressionText(XBlockExpression expression) {
		NodeModelUtils.getNode(expression).text;
	}

	public static def dispatch String getXBlockExpressionText(SimpleTextXBlockExpression blockExpression) {
		blockExpression.text.toString;
	}
	
//	private static def getOptionalReferenceAdapter(EObject element) {
//		element.eAdapters.findFirst [isAdapterForType(ReferenceClassNameAdapter)] as ReferenceClassNameAdapter
//	}
//
//	public static def getJavaClassName(EClassifier eClassifier) {
//		eClassifier.optionalReferenceAdapter?.qualifiedNameForReference ?: eClassifier.instanceClassName
//	}
//	
//	public static def getRuntimeClassName(EObject element) {
//		element.optionalReferenceAdapter?.qualifiedNameForReference ?: element.class.canonicalName
//	}
//
//	public static def getJavaClassName(MetaclassReference metaclassReference) {
//		metaclassReference.metaclass.javaClassName;
//	}
//
//	public static def VitruvDomainProvider<?> getProviderForDomain(VitruvDomain domain) {
//		return VitruvDomainProviderRegistry.getDomainProvider(domain.name);
//	}
//
//	public static def VitruvDomain getDomainForReference(DomainReference domainReference) {
//		return getDomainProviderForReference(domainReference).domain;
//	}
//
//	public static def VitruvDomainProvider<?> getDomainProviderForReference(DomainReference domainReference) {
//		val referencedDomainProvider = VitruvDomainProviderRegistry.getDomainProvider(domainReference.domain)
//		if (referencedDomainProvider === null) {
//			throw new IllegalStateException("Given domain reference references no existing domain");
//		}
//		return referencedDomainProvider;
//	}
//
//	static def Pair<VitruvDomain, VitruvDomain> getSourceTargetPair(ReactionsSegment reactionsSegment) {
//		val sourceDomain = reactionsSegment.fromDomain.domainForReference;
//		val targetDomain = reactionsSegment.toDomain.domainForReference;
//		if (sourceDomain !== null && targetDomain !== null) {
//			return new Pair<VitruvDomain, VitruvDomain>(sourceDomain, targetDomain);
//		} else {
//			return null;
//		}
//	}
//
//	def static ReactionsFile getReactionsFile(Resource resource) {
//		val firstContentElement = resource?.contents?.head
//		checkArgument(firstContentElement instanceof ReactionsFile,
//			"The given resource %s was expected to contain a ReactionsFile element! (was %s)", resource,
//			firstContentElement?.class?.simpleName);
//
//		return firstContentElement as ReactionsFile;
//	}
//	
//	def static getOptionalReactionsFile(Resource resource) {
//		val firstContentElement = resource?.contents?.get(0)
//		if (firstContentElement instanceof ReactionsFile) {
//			firstContentElement
//		} else {
//			null
//		}
//	}
//	
//	def static containsReactionsFile(Resource resource) {
//		resource.optionalReactionsFile !== null
//	}
}
