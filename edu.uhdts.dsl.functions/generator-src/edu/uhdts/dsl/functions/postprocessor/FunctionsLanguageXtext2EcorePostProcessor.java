package edu.uhdts.dsl.functions.postprocessor;

import java.util.Objects;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.xtext.GeneratedMetamodel;
import org.eclipse.xtext.xtext.ecoreInference.IXtext2EcorePostProcessor;

@SuppressWarnings("restriction")
public class FunctionsLanguageXtext2EcorePostProcessor implements IXtext2EcorePostProcessor {
	private static <Sub extends Sup, Sup> Sub requireType(Sup object, Class<Sub> type) {
		Objects.requireNonNull(object);
		return requireType(object, type, "Cannot cast " + object.toString() + " to " + type.toString());
	}

	@SuppressWarnings("unchecked")
	private static <Sub extends Sup, Sup> Sub requireType(Sup object, Class<Sub> type, String errorMessage) {
		Objects.requireNonNull(object);
		if (!(type.isInstance(object))) {
			throw new RuntimeException(errorMessage);
		} else {
			return (Sub) object;
		}
	}

	private static EClass getEClass(EPackage ePackage, String name) {
		return requireType(ePackage.getEClassifier(name), EClass.class);
	}
	
	@Override
	public void process(GeneratedMetamodel metamodel) {
		if (!metamodel.getName().equals("functionsLanguage"))
			return;
		
		final EPackage ePackage = metamodel.getEPackage();
		final EClass functionsFileEClass = getEClass(ePackage, "FunctionsFile");
		final EClass functionEClass = getEClass(ePackage, "Function");
		
		// Add an opposite reference for the metamodel pair to the function
		final EReference functionsFileFunctionsReference = (EReference)functionsFileEClass.getEStructuralFeature("functions");
		addFunctionsFileEReference(functionEClass, functionsFileFunctionsReference);
	}

	private EReference addFunctionsFileEReference(EClass classToAddReferenceTo, EReference oppositeReference) {
		final EReference functionsFileReference = EcoreFactory.eINSTANCE.createEReference();
		functionsFileReference.setName("functionsFile");
		functionsFileReference.setEType(classToAddReferenceTo.getEPackage().getEClassifier("FunctionsFile"));
		functionsFileReference.setLowerBound(1);
		functionsFileReference.setUpperBound(1);
		oppositeReference.setEOpposite(functionsFileReference);
		functionsFileReference.setEOpposite(oppositeReference);
		classToAddReferenceTo.getEStructuralFeatures().add(functionsFileReference);
		return functionsFileReference;
	}
}
