// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//caurina.transitions.SpecialProperty

package caurina.transitions{
    public class SpecialProperty {

        public var getValue:Function;
        public var setValue:Function;
        public var parameters:Array;
        public var preProcess:Function;

        public function SpecialProperty(_arg1:Function, _arg2:Function, _arg3:Array=null, _arg4:Function=null){
            this.getValue = _arg1;
            this.setValue = _arg2;
            this.parameters = _arg3;
            this.preProcess = _arg4;
        }
        public function toString():String{
            var _local1:* = "";
            _local1 = (_local1 + "[SpecialProperty ");
            _local1 = (_local1 + ("getValue:" + String(this.getValue)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("setValue:" + String(this.setValue)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("parameters:" + String(this.parameters)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("preProcess:" + String(this.preProcess)));
            _local1 = (_local1 + "]");
            return (_local1);
        }

    }
}//package caurina.transitions

