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
		final EClass functionsSegmentEClass = getEClass(ePackage, "FunctionsSegment");
		final EClass functionEClass = getEClass(ePackage, "Function");

		// Add an opposite reference for the functions file to the functions segment
		final EReference functionsFileFunctionsSegmentsReference = (EReference) functionsFileEClass.getEStructuralFeature("functionsSegments");
		addOppositeEReference(functionsSegmentEClass, "functionsFile", functionsFileFunctionsSegmentsReference);

		// Add an opposite reference for the metamodel pair to the function
		final EReference functionsSegmentFunctionsReference = (EReference) functionsSegmentEClass.getEStructuralFeature("functions");
		//addFunctionsSegmentEReference(functionEClass, functionsSegmentFunctionsReference);
		addOppositeEReference(functionEClass, "functionsSegment", functionsSegmentFunctionsReference);
	}

	private EReference addOppositeEReference(EClass classToAddReferenceTo, String referenceName, EReference oppositeReference) {
		final EReference reference = EcoreFactory.eINSTANCE.createEReference();
		reference.setName(referenceName);
		// reference.setEType(classToAddReferenceTo.getEPackage().getEClassifier(referenceTypeName));
		reference.setEType(oppositeReference.getEContainingClass());
		reference.setLowerBound(1);
		reference.setUpperBound(1);
		oppositeReference.setEOpposite(reference);
		reference.setEOpposite(oppositeReference);
		classToAddReferenceTo.getEStructuralFeatures().add(reference);
		return reference;
	}
}
