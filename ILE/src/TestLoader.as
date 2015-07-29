package  
{
	import com.iluvas.engine.core.initialBuilders.preloader.ILBPreloader;
	
	/**
	 * ...
	 * @author iluvAS
	 */
	public class TestLoader extends ILBPreloader 
	{
		
		public function TestLoader() 
		{
			autoPlay = true;
			
			TestBuilder
			gameBuilderStr = "TestBuilder";
			
			declareGameProperties(new TestProperties());
		}
		
	}

}