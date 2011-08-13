package{
	
	public class Seating{
		
		/**
		 * імя JavaScript метода, який буде викликатися після ініціалізіції флешки
		 * 
		 * даний метод буде викликатися тільки у веб режимі
		 */
		public static var jsLoadFunction:String = "Ganttzilla.UI.gantViewer.load()"
		
		/**
		 * вказується режим роботи - PDF or PNG
		 */
		public static var exportMode:String = "PDF";
				
		public static var developeMode:Boolean = true;
		
	}
}
