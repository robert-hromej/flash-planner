package{
	
	public class Seating{
		
		/**
		 * імя JavaScript метода, який буде викликатися після ініціалізіції флешки
		 * 
		 * даний метод буде викликатися тільки у веб режимі
		 */
		public static var jsLoadFunction:String = "Ganttzilla.UI.editor.load()";
			
		/**
		 * вказується режим роботи - веб чи десктоп
		 */
		public static var webApplication:Boolean = true;
				
		/**
		 * режим розработчика. у даному режимі, флешка не буде перевіряти доменне імя сайту(тільки у веб режимі)
		 */
		public static var developeMode:Boolean = !false;
		
	}
}
