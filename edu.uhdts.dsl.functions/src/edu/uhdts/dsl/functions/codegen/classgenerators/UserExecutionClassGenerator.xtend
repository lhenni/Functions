package edu.uhdts.dsl.functions.codegen.classgenerators

import edu.uhdts.dsl.functions.codegen.typesbuilder.TypesBuilderExtensionProvider
import edu.uhdts.dsl.functions.functionsLanguage.ExecuteStatement
import edu.uhdts.dsl.functions.functionsLanguage.FunctionCallBlock
import edu.uhdts.dsl.functions.generator.SimpleTextXBlockExpression
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmVisibility
import org.eclipse.xtext.xbase.XExpression

import static edu.uhdts.dsl.functions.codegen.helper.FunctionsLanguageConstants.*

class UserExecutionClassGenerator extends ClassGenerator {
	private val EObject objectMappedToClass;
	private val String qualifiedClassName;
	var counterCallFunctionMethods = 1
	var counterExecuteMethods = 1
	private var JvmGenericType generatedClass

	new(TypesBuilderExtensionProvider typesBuilderExtensionProvider, EObject objectMappedToClass,
		String qualifiedClassName) {
		super(typesBuilderExtensionProvider)
		this.objectMappedToClass = objectMappedToClass;
		this.qualifiedClassName = qualifiedClassName;
	}

	public def String getQualifiedClassName() {
		return qualifiedClassName;
	}

	override generateEmptyClass() {
		this.generatedClass = objectMappedToClass.toClass(qualifiedClassName) [
			visibility = JvmVisibility.PRIVATE
			static = true
		]
		return generatedClass;
	}

	override generateBody() {
		generatedClass => [
			members += generateConstructor()
			members += generatedMethods
		]
	}

	def private generateConstructor() {
		objectMappedToClass.toConstructor() [
			body = '''
				super();
			'''
		]
	}

	protected def JvmOperation generateMethodExecute(ExecuteStatement executeStatement,
		JvmTypeReference facadeClassTypeReference) {
		if (executeStatement.code === null) {
			return null;
		}
		val methodName = "execute" + counterExecuteMethods++;
		return generateExecutionMethod(executeStatement.code, methodName, facadeClassTypeReference)
	}

	protected def JvmOperation generateMethodCallFunction(FunctionCallBlock functionCall,
		JvmTypeReference facadeClassTypeReference) {
		if (functionCall.code === null) {
			return null;
		}
		val methodName = "callFunction" + counterCallFunctionMethods++;
		return generateExecutionMethod(functionCall.code, methodName, facadeClassTypeReference)
	}

	private def JvmOperation generateExecutionMethod(XExpression codeBlock, String methodName,
		JvmTypeReference facadeClassTypeReference) {
		if (codeBlock === null) {
			return null;
		}
		return codeBlock.getOrGenerateMethod(methodName, typeRef(Void.TYPE)) [
			val facadeParam = toParameter(USER_EXECUTION_FUNCTION_CALL_FACADE_PARAMETER_NAME, facadeClassTypeReference);
			facadeParam.annotations += annotationRef(Extension);
			parameters += facadeParam
			if (codeBlock instanceof SimpleTextXBlockExpression) {
				body = codeBlock.text;
			} else {
				body = codeBlock;
			}
		]
	}
}
