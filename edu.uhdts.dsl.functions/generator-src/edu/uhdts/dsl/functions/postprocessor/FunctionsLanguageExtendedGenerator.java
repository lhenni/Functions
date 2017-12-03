package edu.uhdts.dsl.functions.postprocessor;

import org.eclipse.xtext.XtextRuntimeModule;
import org.eclipse.xtext.XtextStandaloneSetup;
import org.eclipse.xtext.xtext.ecoreInference.IXtext2EcorePostProcessor;
import org.eclipse.xtext.xtext.generator.XtextGenerator;

import com.google.inject.Guice;
import com.google.inject.Injector;

@SuppressWarnings("restriction")
public class FunctionsLanguageExtendedGenerator extends XtextGenerator {
	public FunctionsLanguageExtendedGenerator() {
		new XtextStandaloneSetup() {
			public Injector createInjector() {
				return Guice.createInjector(new XtextRuntimeModule() {
					public void configureIXtext2EcorePostProcessor(com.google.inject.Binder binder) {
						binder.bind(IXtext2EcorePostProcessor.class).to(FunctionsLanguageXtext2EcorePostProcessor.class);
					};
				});				
			};			
		}.createInjectorAndDoEMFRegistration();
	}
}
