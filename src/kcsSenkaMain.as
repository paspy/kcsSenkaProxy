package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.NativeWindowBoundsEvent;
    import flash.globalization.DateTimeFormatter;
    import flash.globalization.LocaleID;
    import flash.system.Worker;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    
    import kcsSenka.Consts_Utils;
    import kcsSenka.SenkaWorker;

    /**
     *
     * @author Paspy
     */
    [SWF(width = "800", height = "600", frameRate = "30", backgroundColor = "#FFFFFF")]
    public class kcsSenkaMain extends Sprite {

        /**
         *
         */
        public function kcsSenkaMain() {
            super();
            SetupUI();			
			Log("Cautions: This program may causes your Kancolle account being BAN.");
			Log("Only use secondary account for testing and use as your own risk.");
        }
		
        
        private var logField:TextField;
		private var tokenField:TextField;
		private var progressField:TextField;
		
		private var StartWorkerBtn:TextField;
		private var serversSelections:Vector.<Object>;
		
        private var senkaWorker:SenkaWorker;
		private var inputToken:String;
		
		private var senkaWorkers:Worker;

        private function CreateTextField(x:int, y:int, labelWidth:int, label:String, defaultValue:String = '', editable:Boolean = true, width:int = 200, height:int = 20):TextField {

            var labelField:TextField = new TextField();
            labelField.defaultTextFormat = new TextFormat("Arial", 16);
            labelField.text = label;
            labelField.type = TextFieldType.DYNAMIC;
            labelField.width = labelWidth;
            labelField.x = x;
            labelField.y = y;
            var input:TextField = new TextField();
            input.defaultTextFormat = new TextFormat("Arial", 16);
            input.text = defaultValue;
            input.type = TextFieldType.INPUT;
            input.border = editable;
            input.selectable = editable;
            input.width = width;
            input.height = height;
            input.x = x + labelField.width;
            input.y = y;
            this.addChild(labelField);
            this.addChild(input);
            return input;
        }
		
		private function CreateTextButton( x:int, y:int, label:String, clickHandler:Function ):TextField
		{
			var button:TextField = new TextField();
			button.text = label;
			button.htmlText =  "<font size='16'><b><p align='center'>" + label + "</p align='center'></b></font>";
			button.type = TextFieldType.DYNAMIC;
			button.selectable  =  false;
			button.width = 180;
			button.height = 30;
			button.x = x;
			button.y = y;
			button.addEventListener( MouseEvent.CLICK, clickHandler );
			button.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				if (button.alpha < 1) return;
				button.htmlText =  "<font size='16'><u><b><p align='center'>" + label + "</p align='center'></b></u></font>";
			});
			button.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				if (button.alpha < 1) return;
				button.htmlText =  "<font size='16'><b><p align='center'>" + label + "</p align='center'></b></font>";
			});
			button.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				if (button.alpha < 1) return;
				button.htmlText =  "<font size='18'><u><b><p align='center'>" + label + "</p align='center'></b></u></font>";
			});
			button.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void {
				if (button.alpha < 1) return;
				button.htmlText =  "<font size='16'><u><b><p align='center'>" + label + "</p align='center'></b></u></font>";
			});
			
			this.addChild( button );
			return button;
		}
		
		private function CreateTextSelction( x:int, y:int, label:String, clickHandler:Function ):TextField
		{
			var button:TextField = new TextField();
			button.text = label;
			button.htmlText =  "<font size='14'><u><p align='center'>" + label + "</p align='center'></u></font>";
			button.type = TextFieldType.DYNAMIC;
			button.selectable  =  false;
			button.width = 180;
			button.height = 30;
			button.x = x;
			button.y = y;
			button.addEventListener( MouseEvent.CLICK, clickHandler );
			button.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				if (button.alpha < 1) return;
				button.htmlText =  "<font size='14'><u><b><p align='center'>" + label + "</p align='center'></b></u></font>";
			});
			button.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				if (button.alpha < 1) return;
				button.htmlText =  "<font size='14'><u><p align='center'>" + label + "</p align='center'></u></font>";
			});
			button.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				if (button.alpha < 1) return;
				button.htmlText =  "<font size='15'><u><b><p align='center'>" + label + "</p align='center'></b></u></font>";
			});
			button.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void {
				if (button.alpha < 1) return;
				button.htmlText =  "<font size='14'><u><b><p align='center'>" + label + "</p align='center'></b></u></font>";
			});
			
			this.addChild( button );
			return button;
		}

        private function Log(text:String):void {
            var date:Date = new Date();
            var df:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
            df.setDateTimePattern("[HH:mm:ss] ");
            logField.appendText(df.format(date) + text + "\n");
            logField.scrollV = logField.maxScrollV;
            trace(df.format(date) + text);
        }

		private function OnClickStartWorker(event:MouseEvent):void {
			if (tokenField.text.length > 0 && senkaWorker != null) {
				DisableSelctions();
				senkaWorker.StartWorker();
			} else {
				Log("Please select a server or set API token.");
			}
		}
		
		private function DisableSelctions():void {
			for each(var i:TextField in serversSelections) {
				i.alpha = 0.95;
				
					i.htmlText = (i.text == senkaWorker.WorkerName)?
						"<font size='15' color='#FF8080'><u><b><p align='center'>" + i.text + "</p align='center'></b></u></font>"
						:
						"<font size='14' color='#808080'><u><p align='center'>" + i.text + "</p align='center'></u></font>"
			}
		}
		
		private function EnableSelctions():void {
			for each(var i:TextField in serversSelections) {
				i.alpha = 1;
				i.htmlText = "<font size='14'><u><p align='center'>" + i.text + "</p align='center'></u></font>";
			}
		}

        private function SetupUI():void {
			var lineSpace:int = 20;
            var windowWidth:int = this.stage.nativeWindow.width;
            var windowHeigh:int = this.stage.nativeWindow.height;
			tokenField = CreateTextField(20, 10, 100, "API Token: ", "", true, 400);
			
			StartWorkerBtn = CreateTextButton(tokenField.width + 110, 10, "Start Worker", OnClickStartWorker);
			
			serversSelections = new Vector.<Object>();
			var servers:Array = Consts_Utils.GetSortedPairs(Consts_Utils.Servers);
			for(var i:int=0; i<servers.length; i+=3) {
				for (var j:int=0; j<3; j++) {
					if (i+j<20) {
						var a:String = servers[i+j].value.address;
						var n:String = servers[i+j].value.name;
						var f:Function = function(e:Event):void {
							if (senkaWorker!=null && 
								senkaWorker.WorkerName == e.target.text ||
								e.target.alpha < 1 || tokenField.text.length < 1) return;
							for each(var item:Object in Consts_Utils.Servers) {
								if (e.target.text == item.name) {
									senkaWorker = new SenkaWorker(item.address, item.name, tokenField.text, Log);
									break;
								}
							}
						};
						serversSelections.push(CreateTextSelction(20 + 180*j, 50 + StartWorkerBtn.height*i/3, n, f));
					}
				}
			}
			
            logField = CreateTextField(20, windowHeigh / 2, 50, "Log", "", false, windowWidth - 50 - 10, windowHeigh / 2 - 30);
            this.stage.nativeWindow.activate();
            this.stage.nativeWindow.addEventListener(Event.CLOSING, function(e:Event):void {/*TO DO Release here*/ });
            this.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, function(e:NativeWindowBoundsEvent):void{ e.preventDefault(); });
        }
    }
}
