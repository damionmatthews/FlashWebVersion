// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.adobe.images.PNGEncoder

package com.adobe.images{
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.utils.*;
    import flash.geom.*;

    public class PNGEncoder {

        private static var crcTable:Array;
        private static var crcTableComputed:Boolean = false;

        public static function encode(_arg1:BitmapData):ByteArray{
            var _local2:uint;
            var _local3:int;
            var _local7:int;
            var _local4:ByteArray = new ByteArray();
            _local4.writeUnsignedInt(2303741511);
            _local4.writeUnsignedInt(218765834);
            var _local5:ByteArray = new ByteArray();
            _local5.writeInt(_arg1.width);
            _local5.writeInt(_arg1.height);
            _local5.writeUnsignedInt(134610944);
            _local5.writeByte(0);
            writeChunk(_local4, 1229472850, _local5);
            var _local6:ByteArray = new ByteArray();
            while (_local7 < _arg1.height)
            {
                _local6.writeByte(0);
                if (!_arg1.transparent)
                {
                    _local3 = 0;
                    while (_local3 < _arg1.width)
                    {
                        _local2 = _arg1.getPixel(_local3, _local7);
                        _local6.writeUnsignedInt(uint((((_local2 & 0xFFFFFF) << 8) | 0xFF)));
                        _local3++;
                    };
                } else
                {
                    _local3 = 0;
                    while (_local3 < _arg1.width)
                    {
                        _local2 = _arg1.getPixel32(_local3, _local7);
                        _local6.writeUnsignedInt(uint((((_local2 & 0xFFFFFF) << 8) | (_local2 >>> 24))));
                        _local3++;
                    };
                };
                _local7++;
            };
            _local6.compress();
            writeChunk(_local4, 1229209940, _local6);
            writeChunk(_local4, 1229278788, null);
            return (_local4);
        }
        private static function writeChunk(_arg1:ByteArray, _arg2:uint, _arg3:ByteArray):void{
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            var _local10:int;
            if (!crcTableComputed)
            {
                crcTableComputed = true;
                crcTable = [];
                _local5 = 0;
                while (_local5 < 0x0100)
                {
                    _local4 = _local5;
                    _local6 = 0;
                    while (_local6 < 8)
                    {
                        if ((_local4 & 1))
                        {
                            _local4 = uint((uint(3988292384) ^ uint((_local4 >>> 1))));
                        } else
                        {
                            _local4 = uint((_local4 >>> 1));
                        };
                        _local6++;
                    };
                    crcTable[_local5] = _local4;
                    _local5++;
                };
            };
            if (_arg3 != null)
            {
                _local7 = _arg3.length;
            };
            _arg1.writeUnsignedInt(_local7);
            var _local8:uint = _arg1.position;
            _arg1.writeUnsignedInt(_arg2);
            if (_arg3 != null)
            {
                _arg1.writeBytes(_arg3);
            };
            var _local9:uint = _arg1.position;
            _arg1.position = _local8;
            _local4 = 0xFFFFFFFF;
            while (_local10 < (_local9 - _local8))
            {
                _local4 = uint((crcTable[((_local4 ^ _arg1.readUnsignedByte()) & uint(0xFF))] ^ uint((_local4 >>> 8))));
                _local10++;
            };
            _local4 = uint((_local4 ^ uint(0xFFFFFFFF)));
            _arg1.position = _local9;
            _arg1.writeUnsignedInt(_local4);
        }

    }
}//package com.adobe.images

