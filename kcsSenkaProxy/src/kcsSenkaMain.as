package
{
	import flash.display.Sprite;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;
	import flash.net.DatagramSocket;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import kcsCore._APIBaseS_;
	
	[SWF(width="900", height="600", frameRate="60", backgroundColor="#FFFFFF")]
    public class kcsSenkaMain extends Sprite
    {
		private static const ASPECT_RATIO:Number = 1.0; //2:1 Aspect Ratio
		
		private var api_ranking:String;
		private var API_Encoder:_APIBaseS_;
		private var logField:TextField;
		private var UDPSocket:DatagramSocket; // UDP Socket
		
		private var senkaWorker:kcsSenkaWorker;
		
        public function kcsSenkaMain() {
            super();
			SetupUI();
			InitUDPSocket();
			senkaWorker = new kcsSenkaWorker(Consts.Server_09, Consts.Server_09_api_token, Log);
        }
			
		private function InitUDPSocket() :void {
			API_Encoder = new _APIBaseS_();
			UDPSocket = new DatagramSocket();
			try {
				UDPSocket.addEventListener(DatagramSocketDataEvent.DATA, UDPSocketReceived);
				UDPSocket.bind(Consts.DefaultPort, Consts.LocalIP);
				UDPSocket.receive();
				Log("kcsSenka Initialized.");
				
			} catch(e:Error) {
				Log(e.message);
				return;
			}
			
			Log("Listen at port: " + Consts.LocalIP + " : " + Consts.DefaultPort);
		}
		
		private function UDPSocketReceived(event:DatagramSocketDataEvent):void {
			try {
				var receivedMsg:String = event.data.readUTFBytes(event.data.bytesAvailable);
				var srcAddress:String = event.srcAddress;
				var srcPort:int = event.srcPort;
				Log("Received from " + srcAddress + ":" + srcPort + "> " + receivedMsg);
				if (receivedMsg.substr(0,Consts.RequestRankingAPI.length) == Consts.RequestRankingAPI) {
					senkaWorker.StartWorker(); return;
					var memberId:String = receivedMsg.substr(Consts.RequestRankingAPI.length);
					Log("Member ID is " + memberId);
					var data:ByteArray = new ByteArray();
					var sendMsg:String = Consts.EncodedRankingAPI + GetAPI_ranking(memberId);
					data.writeUTFBytes(sendMsg);
					UDPSocket.send(data, 0, 0, srcAddress, Consts.TargetPort);
					Log("Send to " + srcAddress + ":" + srcPort + "> " +sendMsg);
				}
			} catch(e:Error) {
				Log(e.message);
			}
		}
		
		private function GetAPI_ranking(memberId:String):String {
			return API_Encoder.__(parseInt(memberId),API_Encoder._createKey());
		}
		
		private function SetupUI():void {
			var windowWidth:int = this.stage.nativeWindow.width;
			var windowHeigh:int = this.stage.nativeWindow.height;
			logField = CreateTextField( 10, windowHeigh / 2, "Log", "", false, windowWidth - 50 - 10, windowHeigh / 2 - 30 );
			
			this.stage.nativeWindow.activate();
			this.stage.nativeWindow.addEventListener(Event.CLOSING, OnCloseCall);
			this.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, OnResizeEventHandler);
		}
		
		private function OnCloseCall(evt:Event):void {
			evt.preventDefault();
			if (UDPSocket != null) {
				UDPSocket.removeEventListener(DatagramSocketDataEvent.DATA, UDPSocketReceived);
				UDPSocket.close();
			}
			this.stage.nativeWindow.removeEventListener(NativeWindowBoundsEvent.RESIZING, OnResizeEventHandler);
			this.stage.nativeWindow.removeEventListener(Event.CLOSING, OnCloseCall);
			this.stage.nativeWindow.close();
		}
		
		private function OnResizeEventHandler(evt:NativeWindowBoundsEvent):void {
			evt.preventDefault();
		}
		
		private function CreateTextField( 
			x:int, y:int, 
			label:String, 
			defaultValue:String = '', 
			editable:Boolean = true, width:int = 200, height:int = 20 ):TextField
		{
			
			var labelField:TextField = new TextField();
			labelField.defaultTextFormat = new TextFormat("Arial", 16);
			labelField.text = label;
			labelField.type = TextFieldType.DYNAMIC;
			labelField.width = 50;
			labelField.x = x;
			labelField.y = y;
			var input:TextField = new TextField();
			input.defaultTextFormat= new TextFormat("Arial", 16);
			input.text = defaultValue;
			input.type = TextFieldType.INPUT;
			input.border = editable;
			input.selectable = editable;
			input.width = width;
			input.height = height;
			input.x = x + labelField.width;
			input.y = y;
			this.addChild( labelField );
			this.addChild( input );
			return input;
		}
		
		private function Log( text:String, color:uint = 0x000000 ):void {
			var date:Date = new Date();
			var df:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
			logField.textColor = color;
			df.setDateTimePattern("[HH:mm:ss] ");
			logField.appendText(df.format(date) + text + "\n" );
			logField.scrollV = logField.maxScrollV;
			trace( df.format(date) + text );
		}
    }
}
