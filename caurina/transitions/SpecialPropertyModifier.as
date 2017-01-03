// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//caurina.transitions.SpecialPropertyModifier

package caurina.transitions{
    public class SpecialPropertyModifier {

        public var modifyValues:Function;
        public var getValue:Function;

        public function SpecialPropertyModifier(_arg1:Function, _arg2:Function){
            this.modifyValues = _arg1;
            this.getValue = _arg2;
        }
        public function toString():String{
            var _local1:* = "";
            _local1 = (_local1 + "[SpecialPropertyModifier ");
            _local1 = (_local1 + ("modifyValues:" + String(this.modifyValues)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("getValue:" + String(this.getValue)));
            _local1 = (_local1 + "]");
            return (_local1);
        }

    }
}//package caurina.transitions

