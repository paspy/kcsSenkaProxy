package kcsSenka {
    import flash.events.DatagramSocketDataEvent;
    import flash.net.DatagramSocket;
    import flash.utils.ByteArray;
    import kcsCore._APIBaseS_;

    public class SenkaProxy {

        public function SenkaProxy(_log:Function) {
            Log=_log;
        }

        private var API_Encoder:_APIBaseS_;
        private var Log:Function;
        private var UDPSocket:DatagramSocket; // UDP Socket
        private var api_ranking:String;

        public function CloseSocket():void {
            if (UDPSocket != null) {
                UDPSocket.removeEventListener(DatagramSocketDataEvent.DATA, UDPSocketReceived);
                UDPSocket.close();
            }
        }

        private function GetAPI_ranking(memberId:String):String {
            return API_Encoder.__(parseInt(memberId), API_Encoder._createKey());
        }

        private function InitUDPSocket():void {
            API_Encoder=new _APIBaseS_();
            UDPSocket=new DatagramSocket();
            try {
                UDPSocket.addEventListener(DatagramSocketDataEvent.DATA, UDPSocketReceived);
                UDPSocket.bind(Consts.DefaultPort, Consts.LocalIP);
                UDPSocket.receive();
                Log("kcsSenka Initialized.");

            } catch (e:Error) {
                Log(e.message);
                return;
            }

            Log("Listen at port: " + Consts.LocalIP + " : " + Consts.DefaultPort);
        }

        private function UDPSocketReceived(event:DatagramSocketDataEvent):void {
            try {
                var receivedMsg:String=event.data.readUTFBytes(event.data.bytesAvailable);
                var srcAddress:String=event.srcAddress;
                var srcPort:int=event.srcPort;
                Log("Received from " + srcAddress + ":" + srcPort + "> " + receivedMsg);
                if (receivedMsg.substr(0, Consts.RequestRankingAPI.length) == Consts.RequestRankingAPI) {
                    var memberId:String=receivedMsg.substr(Consts.RequestRankingAPI.length);
                    Log("Member ID is " + memberId);
                    var data:ByteArray=new ByteArray();
                    var sendMsg:String=Consts.EncodedRankingAPI + GetAPI_ranking(memberId);
                    data.writeUTFBytes(sendMsg);
                    UDPSocket.send(data, 0, 0, srcAddress, Consts.TargetPort);
                    Log("Send to " + srcAddress + ":" + srcPort + "> " + sendMsg);
                }
            } catch (e:Error) {
                Log(e.message);
            }
        }
    }
}
