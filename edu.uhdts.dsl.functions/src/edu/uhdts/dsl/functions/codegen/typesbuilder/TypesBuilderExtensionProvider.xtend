package edu.uhdts.dsl.functions.codegen.typesbuilder

import org.eclipse.xtext.xbase.jvmmodel.JvmTypeReferenceBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmAnnotationReferenceBuilder

class TypesBuilderExtensionProvider {
	protected extension JvmTypesBuilderWithoutAssociations _typesBuilder;
	protected extension JvmTypeReferenceBuilder _typeReferenceBuilder;
	protected extension JvmAnnotationReferenceBuilder _annotationTypesBuilder; 
	
	public def void setBuilders(JvmTypesBuilderWithoutAssociations typesBuilder, JvmTypeReferenceBuilder typeReferenceBuilder, JvmAnnotationReferenceBuilder annotationReferenceBuilder) {
		this._typesBuilder = typesBuilder;
		this._typeReferenceBuilder = typeReferenceBuilder;
		this._annotationTypesBuilder = annotationReferenceBuilder;
	}
	
	public def copyBuildersTo(TypesBuilderExtensionProvider typesBuilderExtensionProvider) {
		typesBuilderExtensionProvider._typesBuilder = _typesBuilder;
		typesBuilderExtensionProvider._typeReferenceBuilder = _typeReferenceBuilder;
		typesBuilderExtensionProvider._annotationTypesBuilder = _annotationTypesBuilder;
	}
}
	