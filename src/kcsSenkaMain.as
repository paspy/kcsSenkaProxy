package {
	
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.NativeWindowBoundsEvent;
    import flash.globalization.DateTimeFormatter;
    import flash.globalization.LocaleID;
    import flash.system.MessageChannel;
    import flash.system.Worker;
    import flash.system.WorkerDomain;
    import flash.system.WorkerState;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
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
			
			// Check to see if this is the primordial worker or the background worker 
			if (Worker.current.isPrimordial) { 
				senkaWorkers = new Dictionary();
				activeWorkerMsg = new Dictionary();
				
				bgWorkerCommandChannels = new Dictionary();
				workerLogChannels = new Dictionary();
				resultChannels = new Dictionary();
				
				SetupUI();
				Log("Cautions: This program may causes your Kancolle account being BAN.");
				Log("Only use secondary account for testing and use as your own risk.");
				// ... set up worker communication and start the worker 
				
				// create 20 workers
				for each(var item:Object in Consts_Utils.Servers) {
					
					senkaWorkers[item.name] = WorkerDomain.current.createWorker(this.loaderInfo.bytes, true);
					
					bgWorkerCommandChannels[item.name] = Worker.current.createMessageChannel((senkaWorkers[item.name] as Worker));
					
					(senkaWorkers[item.name] as Worker).
						setSharedProperty("incomingCommandChannel", bgWorkerCommandChannels[item.name] as MessageChannel);
					
					
					workerLogChannels[item.name] = (senkaWorkers[item.name] as Worker).createMessageChannel(Worker.current);
					
					(workerLogChannels[item.name] as MessageChannel).addEventListener(Event.CHANNEL_MESSAGE, handleWorkerLogMessage);
					
					(senkaWorkers[item.name] as Worker).setSharedProperty("logChannel", (workerLogChannels[item.name] as MessageChannel));
					
					resultChannels[item.name] = (senkaWorkers[item.name] as Worker).createMessageChannel(Worker.current);
					resultChannels[item.name].addEventListener(Event.CHANNEL_MESSAGE, handleResultMessage);
					(senkaWorkers[item.name] as Worker).setSharedProperty("resultChannel", resultChannels[item.name] as MessageChannel);
					
					(senkaWorkers[item.name] as Worker).addEventListener(Event.WORKER_STATE, handleBGWorkerStateChange);
					
					activeWorkerMsg[item.name] = null;
				}
				
			} else{  // entry point for the background worker 

				commandChannel = Worker.current.getSharedProperty("incomingCommandChannel") as MessageChannel;
				commandChannel.addEventListener(Event.CHANNEL_MESSAGE, handleCommandMessage);
			}  
        }
		
		// for worker thread
		private var senkaWorkerThread:SenkaWorker;	
		private var commandChannel:MessageChannel;
		
		private function handleCommandMessage(event:Event):void
		{
			if (!commandChannel.messageAvailable)
				return;
			
			var message:Object = commandChannel.receive() as Object;
			
			if (message != null && message.command == "startWork") {
				
				senkaWorkerThread = new SenkaWorker(message.server, message.workName,message.token,message.maxPage);
				senkaWorkerThread.StartWorker();
			}
		}
		
		// for parent thread
		private var senkaWorkers:Dictionary;
		private var activeWorkerMsg:Dictionary;
		
		private var bgWorkerCommandChannels:Dictionary;
		private var workerLogChannels:Dictionary;
		private var resultChannels:Dictionary;
		
		// problem used to here 
		private function handleBGWorkerStateChange(event:Event):void
		{
			if (event.target.state == WorkerState.RUNNING) 
			{
				for each(var server:Object in Consts_Utils.Servers) {	
					if (activeWorkerMsg[server.name] != null) {
						Log(server.name + " worker has been started.");
						bgWorkerCommandChannels[server.name].send(activeWorkerMsg[server.name]);
						activeWorkerMsg[server.name] = null;
					}
				}
			}
		}
		
		
		private function handleWorkerLogMessage(event:Event):void {
			var log:String = (event.target as MessageChannel).receive();
			Log(log);
		}
		
		
		private function handleResultMessage(event:Event):void {
			var log:Object = (event.target as MessageChannel).receive();
			Log(log.log);
			
		}
		
		// ------- Parent UI Stuff-------

        private var logField:TextField;
		private var tokenField:TextField;
		private var progressField:TextField;
		
		private var StartWorkerBtn:TextField;
		private var serversSelections:Vector.<Object>;
        
		private var inputToken:String;
		
		
		
		
		
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
						var name:String = servers[i+j].value.name;
						serversSelections.push(CreateTextSelction(20 + 220*j, 50 + StartWorkerBtn.height*i/2.5, name, OnClickServerSelection));
					}
				}
			}
			
			logField = CreateTextField(20, windowHeigh / 2, 50, "Log", "", false, windowWidth - 50 - 10, windowHeigh / 2 - 30);
			this.stage.nativeWindow.activate();
			this.stage.nativeWindow.addEventListener(Event.CLOSING, function(e:Event):void {/*TO DO Release here*/ });
			this.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, function(e:NativeWindowBoundsEvent):void{ e.preventDefault(); });
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
			
			for each(var server:Object in Consts_Utils.Servers) {	
				if (activeWorkerMsg[server.name] != null) {
					senkaWorkers[server.name].start();
				}
			}
			DisableSelctions();

		}
		
		private function OnClickServerSelection(e:Event):void {
			if (activeWorkerMsg[e.target.text] != null || e.target.alpha < 1 || tokenField.text.length < 1) return;
			var msg:Object = new Object();
			msg.command = "startWork";
			msg.server = Consts_Utils.ServerNameToAddr[e.target.text];
			msg.workName = e.target.text;
			msg.token = tokenField.text;
			msg.maxPage = 99;				// page number
			activeWorkerMsg[e.target.text] = msg;
			Log("Server " + e.target.text + " now is an active worker.");
			Log("Token is " + msg.token + ".");
			tokenField.text = "";
		};
		
		private function DisableSelctions():void {
			for each(var i:TextField in serversSelections) {
				i.alpha = 0.95;
				
					i.htmlText = (activeWorkerMsg[i.text] != null)?
						"<font size='15' color='#80FF80'><u><b><p align='center'>" + i.text + "</p align='center'></b></u></font>"
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
    }
}
