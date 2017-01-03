// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//caurina.transitions.PropertyInfoObj

package caurina.transitions{
    public class PropertyInfoObj {

        public var valueStart:Number;
        public var valueComplete:Number;
        public var originalValueComplete:Object;
        public var arrayIndex:Number;
        public var extra:Object;
        public var isSpecialProperty:Boolean;
        public var hasModifier:Boolean;
        public var modifierFunction:Function;
        public var modifierParameters:Array;

        public function PropertyInfoObj(_arg1:Number, _arg2:Number, _arg3:Object, _arg4:Number, _arg5:Object, _arg6:Boolean, _arg7:Function, _arg8:Array){
            this.valueStart = _arg1;
            this.valueComplete = _arg2;
            this.originalValueComplete = _arg3;
            this.arrayIndex = _arg4;
            this.extra = _arg5;
            this.isSpecialProperty = _arg6;
            this.hasModifier = Boolean(_arg7);
            this.modifierFunction = _arg7;
            this.modifierParameters = _arg8;
        }
        public function clone():PropertyInfoObj{
            var _local1:PropertyInfoObj = new PropertyInfoObj(this.valueStart, this.valueComplete, this.originalValueComplete, this.arrayIndex, this.extra, this.isSpecialProperty, this.modifierFunction, this.modifierParameters);
            return (_local1);
        }
        public function toString():String{
            var _local1:* = "\n[PropertyInfoObj ";
            _local1 = (_local1 + ("valueStart:" + String(this.valueStart)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("valueComplete:" + String(this.valueComplete)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("originalValueComplete:" + String(this.originalValueComplete)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("arrayIndex:" + String(this.arrayIndex)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("extra:" + String(this.extra)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("isSpecialProperty:" + String(this.isSpecialProperty)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("hasModifier:" + String(this.hasModifier)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("modifierFunction:" + String(this.modifierFunction)));
            _local1 = (_local1 + ", ");
            _local1 = (_local1 + ("modifierParameters:" + String(this.modifierParameters)));
            _local1 = (_local1 + "]\n");
            return (_local1);
        }

    }
}//package caurina.transitions

