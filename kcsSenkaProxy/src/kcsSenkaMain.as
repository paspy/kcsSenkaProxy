package {
    import flash.display.Sprite;
    import flash.events.DatagramSocketDataEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.NativeWindowBoundsEvent;
    import flash.filesystem.File;
    import flash.globalization.DateTimeFormatter;
    import flash.globalization.LocaleID;
    import flash.net.DatagramSocket;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.utils.ByteArray;
    import kcsCore._APIBaseS_;
    import kcsSenka.Consts;
    import kcsSenka.SenkaWorker;
    [SWF(width="900", height="600", frameRate="60", backgroundColor="#FFFFFF")]
    /**
     *
     * @author Paspy
     */
    public class kcsSenkaMain extends Sprite {

        /**
         *
         */
        public function kcsSenkaMain() {
            super();
            SetupUI();
            //InitUDPSocket();
            senkaWorker=new SenkaWorker(Consts.Server_09, Consts.Server_09_api_token, Log);
            root.loaderInfo.addEventListener(Event.INIT, OnInit);
        }

        private var API_Encoder:_APIBaseS_;
        private var api_ranking:String;
        private var logField:TextField;
        private var rootPath:String;

        private var senkaWorker:SenkaWorker;

        private function CreateTextField(x:int, y:int, label:String, defaultValue:String='', editable:Boolean=true, width:int=200, height:int=20):TextField {

            var labelField:TextField=new TextField();
            labelField.defaultTextFormat=new TextFormat("Arial", 16);
            labelField.text=label;
            labelField.type=TextFieldType.DYNAMIC;
            labelField.width=50;
            labelField.x=x;
            labelField.y=y;
            var input:TextField=new TextField();
            input.defaultTextFormat=new TextFormat("Arial", 16);
            input.text=defaultValue;
            input.type=TextFieldType.INPUT;
            input.border=editable;
            input.selectable=editable;
            input.width=width;
            input.height=height;
            input.x=x + labelField.width;
            input.y=y;
            this.addChild(labelField);
            this.addChild(input);
            return input;
        }

        private function Log(text:String):void {
            var date:Date=new Date();
            var df:DateTimeFormatter=new DateTimeFormatter(LocaleID.DEFAULT);
            df.setDateTimePattern("[HH:mm:ss] ");
            logField.appendText(df.format(date) + text + "\n");
            logField.scrollV=logField.maxScrollV;
            trace(df.format(date) + text);
        }

        private function OnCloseCall(evt:Event):void {
            evt.preventDefault();
            this.stage.nativeWindow.removeEventListener(NativeWindowBoundsEvent.RESIZING, OnResizeEventHandler);
            this.stage.nativeWindow.removeEventListener(Event.CLOSING, OnCloseCall);
            this.stage.nativeWindow.close();
        }

        private function OnInit(ev:Event):void {
            rootPath=File.applicationDirectory.resolvePath("").nativePath;
            root.loaderInfo.removeEventListener(Event.INIT, OnInit);
        }

        private function OnResizeEventHandler(evt:NativeWindowBoundsEvent):void {
            evt.preventDefault();
        }


        private function SetupUI():void {
            var windowWidth:int=this.stage.nativeWindow.width;
            var windowHeigh:int=this.stage.nativeWindow.height;
            logField=CreateTextField(10, windowHeigh / 2, "Log", "", false, windowWidth - 50 - 10, windowHeigh / 2 - 30);

            this.stage.nativeWindow.activate();
            this.stage.nativeWindow.addEventListener(Event.CLOSING, OnCloseCall);
            this.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, OnResizeEventHandler);
        }
    }
}
