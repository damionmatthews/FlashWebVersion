// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//caurina.transitions.AuxFunctions

package caurina.transitions{
    public class AuxFunctions {

        public static function numberToR(_arg1:Number):Number{
            return (((_arg1 & 0xFF0000) >> 16));
        }
        public static function numberToG(_arg1:Number):Number{
            return (((_arg1 & 0xFF00) >> 8));
        }
        public static function numberToB(_arg1:Number):Number{
            return ((_arg1 & 0xFF));
        }
        public static function getObjectLength(_arg1:Object):uint{
            var _local2:String;
            var _local3:uint;
            for (_local2 in _arg1)
            {
                _local3++;
            };
            return (_local3);
        }
        public static function concatObjects(... _args):Object{
            var _local2:Object;
            var _local3:String;
            var _local5:int;
            var _local4:Object = {};
            while (_local5 < _args.length)
            {
                _local2 = _args[_local5];
                for (_local3 in _local2)
                {
                    if (_local2[_local3] == null)
                    {
                        delete _local4[_local3];
                    } else
                    {
                        _local4[_local3] = _local2[_local3];
                    };
                };
                _local5++;
            };
            return (_local4);
        }

    }
}//package caurina.transitions

