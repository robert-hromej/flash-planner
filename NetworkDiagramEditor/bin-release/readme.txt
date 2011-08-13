network_diagram.swf-ка аналогічно до planner-editor.swf буде працювати з javascript-ом.
після ініціалізації флешка буде викликати "Ganttzilla.UI.pertViewer.load()" функцію.
в режимі вювера для флешки буде доступний тільки один метод: "load(plannerFile:String)".

для режима едітора потрібно буде прописати параметр флешки editor="true" тобто: <embed src="..." flashvars="editor=true" .../>
в режимі вювера для флешки будуть доступні 2 метода: "load(plannerFile:String):void", "save():String"

для динамічного ресайзінга потрібно буде поставити властивості флешки <embed src="..." width="100%" height="100%" />


