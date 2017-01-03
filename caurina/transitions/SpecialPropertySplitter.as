// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//caurina.transitions.SpecialPropertySplitter

package caurina.transitions{
    public class SpecialPropertySplitter {

        public var parameters:Array;
        public var splitValues:Function;

        public function SpecialPropertySplitter(_arg1:Function, _arg2:Array){
            this.splitValues = _arg1;
            this.parameters = _arg2;
        }
        public function toString():String{
            var _local1:* = "";
            _local1 = (_local1 + "[SpecialPropertySplitter ");
            _local1 = (_local1 + ("splitValues:" + String(this.splitValues)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("parameters:" + String(this.parameters)));
            _local1 = (_local1 + "]");
            return (_local1);
        }

    }
}//package caurina.transitions

