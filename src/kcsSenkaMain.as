package {
	
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.NativeWindowBoundsEvent;
    import flash.events.TimerEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.globalization.DateTimeFormatter;
    import flash.globalization.LocaleID;
    import flash.net.FileFilter;
    import flash.system.MessageChannel;
    import flash.system.Worker;
    import flash.system.WorkerDomain;
    import flash.system.WorkerState;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    
    import kcsSenka.Consts_Utils;
    import kcsSenka.SenkaWorker;

    /**
     *
     * @author Paspy
     */
    [SWF(width = "1024", height = "768", frameRate = "60", backgroundColor = "#FFFFFF")]
    public class kcsSenkaMain extends Sprite {

        /**
         *
         */
        public function kcsSenkaMain() {
            super();
			
			// Check to see if this is the primordial worker or the background worker 
			if (Worker.current.isPrimordial) { 
				SetupUI();
				InitParentThread();	
				
			} else{  // entry point for the background worker 
				commandChannel = Worker.current.getSharedProperty("incomingCommandChannel") as MessageChannel;
				commandChannel.addEventListener(Event.CHANNEL_MESSAGE, handleCommandMessage);
			}  
        }
		
		// for worker thread
		private var senkaWorkerThread:SenkaWorker;	
		private var commandChannel:MessageChannel;
		
		private function handleCommandMessage(event:Event):void {
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
		
		// problem used at here 
		
		private function InitParentThread(): void {
			senkaWorkers = new Dictionary();
			activeWorkerMsg = new Dictionary();
			activeWorkerMsg["ActiveWorkers"] = 0;
			
			bgWorkerCommandChannels = new Dictionary();
			workerLogChannels = new Dictionary();
			resultChannels = new Dictionary();
			
			logField.text = "";
			Log("CAUTIONS: This program may causes your Kancolle account being BANNED.");
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
		}
		
		private function handleBGWorkerStateChange(event:Event):void
		{
			if (event.target.state == WorkerState.RUNNING) 
			{
				for each(var server:Object in Consts_Utils.Servers) {	
					if (activeWorkerMsg[server.name] != null && !activeWorkerMsg[server.name].sent) {
						bgWorkerCommandChannels[server.name].send(activeWorkerMsg[server.name]);
						activeWorkerMsg[server.name].sent = true;
						Log(server.name + " worker has been started.");
					}
				}
			}
		}
		
		
		private function handleWorkerLogMessage(event:Event):void {
			var log:String = (event.target as MessageChannel).receive();
			Log(log);
		}
		
		
		private function handleResultMessage(event:Event):void {
			var result:Object = (event.target as MessageChannel).receive();
			Log(result.log);
			if ( result !=null && result.command == "workFinished") {
				if((senkaWorkers[result.workerName] as Worker).terminate() && activeWorkerMsg[result.workerName].sent) {
					Log("Worker Thread: " + result.workerName + " has been terminated.(Work Finished)")
				}
				serversSelections[result.workerName].htmlText =
					"<font size='14' color='#80FF80'><u><b><p align='center'>" + 
						serversSelections[result.workerName].text + 
					"</p align='center'></b></u></font>";
				
			}
			if ( result !=null && result.command == "workError") {
				if((senkaWorkers[result.workerName] as Worker).terminate() && activeWorkerMsg[result.workerName].sent) {
					Log("Worker Thread: " + result.workerName + " has been terminated. (Work Error)")
				}
				serversSelections[result.workerName].htmlText =
					"<font size='14' color='#FF0000'><u><b><p align='center'>" + 
						serversSelections[result.workerName].text + 
					"</p align='center'></b></u></font>";
			}
			activeWorkerMsg[result.workerName] = null;
		}
		
		// ------- Parent UI Stuff-------

		private var tokenField:TextField;
        private var logField:TextField;
//		private var progressField:TextField;
		
		private var OpenFileBtn:TextField;
		private var StartWorkerBtn:TextField;
		private var serversSelections:Dictionary;
        
		private var inputToken:String;
		
		private var jstTimeFiled:TextField;
		private var systemTime:Timer;
		
		private function SetupUI():void {
			var lineSpace:int = 20;
			var windowWidth:int = this.stage.nativeWindow.width;
			var windowHeigh:int = this.stage.nativeWindow.height;
			
			tokenField = CreateTextField((50 + windowWidth / 2) - 400, 50, 100, "API Token: ", "", true, 400);
			
			StartWorkerBtn = CreateTextButton((50 + windowWidth / 2) - 400 + tokenField.width + 110, 50, "Start Worker(s)", OnClickStartWorker);
			OpenFileBtn = CreateTextButton( 30, 10, "Import Tokens", OnClickOpenTokens);
			
			serversSelections = new Dictionary();
			var servers:Array = Consts_Utils.GetSortedPairs(Consts_Utils.Servers);
			for(var i:int=0; i<servers.length; i+=3) {
				for (var j:int=0; j<3; j++) {
					if (i+j<20) {
						var name:String = servers[i+j].value.name;
						serversSelections[name] = (CreateTextSelction(20 + 300*j, 100 + StartWorkerBtn.height*i/2, name, OnClickServerSelection));
					}
				}
			}
			logField = CreateTextField(20, windowHeigh / 1.95, 50, "Log", "", false, windowWidth - 160, windowHeigh / 2 - 70);
			jstTimeFiled = CreateTextField( 630, 100 + StartWorkerBtn.height*18/2, 40, "JST: ", "00:00:00", false);
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
		
		private function OnClickStartWorker(e:MouseEvent):void {
			if (e.target.alpha < 1) return;
			for each(var server:Object in Consts_Utils.Servers) {	
				if (activeWorkerMsg[server.name] != null && !activeWorkerMsg[server.name].sent) {
					senkaWorkers[server.name].start();
				}
			}
			if (activeWorkerMsg["ActiveWorkers"] > 0)
				DisableSelctions();

		}
		
		private function OnClickOpenTokens(e:MouseEvent):void {
			var fileToOpen:File = new File();
			var txtFilter:FileFilter = new FileFilter("*.xml", "*.xml");
			
			try  {
				fileToOpen.browseForOpen("Open", [txtFilter]);
				fileToOpen.addEventListener(Event.SELECT, ImportXMLTokensHandler);
			} catch (error:Error) {
				Log("Failed:" + error.message);
			}
		}
		
		private function OnClickServerSelection(e:Event):void {
			if (activeWorkerMsg[e.target.text] != null || e.target.alpha < 1 || tokenField.text.length < 1) return;
			var msg:Object = new Object();
			msg.command = "startWork";
			msg.server = Consts_Utils.ServerNameToAddr[e.target.text];
			msg.workName = e.target.text;
			msg.token = tokenField.text;
			msg.maxPage = 99;				// page number
			msg.sent = false;
			activeWorkerMsg[e.target.text] = msg;
			activeWorkerMsg["ActiveWorkers"]++; // active one worker
			Log("Server " + e.target.text + " now is an active worker.");
			Log("Token is " + msg.token + ".");
			tokenField.text = "";
		};
		
		private function ImportXMLTokensHandler(e:Event): void {
			var stream:FileStream = new FileStream();
			stream.open((e.target as File), FileMode.READ);
			var fileData:String = stream.readUTFBytes(stream.bytesAvailable).replace(/[\u000d\u000a]+/g,""); //remove any LF CR
			var xmlDoc:XML = new XML(fileData);
			var tokenList:XMLList = xmlDoc.Token;
			if (tokenList.length() > 0) {
				for each (var token:XML in tokenList) {
					if (token.text().toString() == "") continue;
					if (token.text().toString().length > 0 && token.text().toString().length != 40) {
						Log("The following token format is wrong: " + token.text().toString());
						continue;
					}
					var msg:Object = new Object();
					msg.command = "startWork";
					msg.server = Consts_Utils.ServerNameToAddr[token.attribute("name").toString()];
					msg.workName = token.attribute("name").toString();
					msg.token = token.text().toString();
					msg.maxPage = 99;				// page number
					msg.sent = false;
					activeWorkerMsg[token.attribute("name").toString()] = msg;
					activeWorkerMsg["ActiveWorkers"]++; // active one worker
					Log("Server " + token.attribute("name").toString() + " now is an active worker. Token is " + msg.token + ".");
				}
				Log("Load token XML completed.");
			} else {
				Log("Load token XML failed.");
			}
		}
		
		private function DisableSelctions():void {
			for each(var i:TextField in serversSelections) {
				i.alpha = 0.95;
				i.htmlText = (activeWorkerMsg[i.text] != null)?
					"<font size='15' color='#8080FF'><u><b><p align='center'>" + i.text + "</p align='center'></b></u></font>"
					:
					"<font size='14' color='#808080'><u><p align='center'>" + i.text + "</p align='center'></u></font>"
			}
			tokenField.alpha = 0.95;
			tokenField.type = TextFieldType.DYNAMIC;
			tokenField.backgroundColor = 0xF0F0F0;
			
			StartWorkerBtn.alpha = 0.95;
			StartWorkerBtn.htmlText =
				"<font size='14' color='#808080'><u><p align='center'>" + StartWorkerBtn.text + "</p align='center'></u></font>"
		}
		
		private function EnableSelctions():void {
			for each(var i:TextField in serversSelections) {
				i.alpha = 1;
				i.htmlText = "<font size='14'><u><p align='center'>" + i.text + "</p align='center'></u></font>";
			}
			tokenField.type = TextFieldType.INPUT;
			
			StartWorkerBtn.alpha = 1;
			StartWorkerBtn.htmlText = 
				"<font size='15' color='#80FF80'><u><b><p align='center'>" + i.text + "</p align='center'></b></u></font>";
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
			input.background = true;
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
