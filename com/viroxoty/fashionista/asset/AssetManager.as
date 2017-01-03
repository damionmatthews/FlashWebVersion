// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.asset.AssetManager

package com.viroxoty.fashionista.asset{
    import flash.display.Bitmap;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public dynamic class AssetManager {

        private static var _instance:AssetManager;

        private var loader:AssetLoader;
        private var assets:Object;
        private var requesters:Object;

        public function AssetManager(){
            this.loader = new AssetLoader(this);
            this.assets = {};
            this.requesters = {};
        }
        public static function getInstance():AssetManager{
            if (_instance == null)
            {
                _instance = new (AssetManager)();
            };
            return (_instance);
        }

        public function getAssetFor(_arg1:AssetDataObject, _arg2:Object):void{
            var _local3:*;
            var _local4:String = _arg1.url;
            _arg1.url = _local4;
            if (this.assets[_local4] != null)
            {
                _local3 = this.assets[_local4];
                if ((_local3 is Class))
                {
                    this.instantiateAssetFor(_local3, _arg2, _local4);
                } else
                {
                    if ((_local3 is Bitmap))
                    {
                        this.copyAssetFor(_local3, _arg2, _local4);
                    } else
                    {
                        Tracer.out("AssetManager > getAssetFor: error: unrecognized asset type");
                    };
                };
                return;
            };
            if (this.requesters[_local4] == null)
            {
                this.requesters[_local4] = new Array();
                this.loader.loadAsset(_arg1);
            };
            this.requesters[_local4].push(_arg2);
        }
        public function holdCurrentQueue():void{
            trace("AssetManager > holdCurrentQueue");
            this.loader.holdCurrentQueue();
        }
        public function resetUrl(_arg1:String):void{
            trace(("AssetManager > resetUrl " + _arg1));
            this.assets[_arg1] = null;
        }
        public function removeAsset(_arg1:String):void{
            this.resetUrl(_arg1);
        }
        function bitmapAssetLoaded(_arg1:Bitmap, _arg2:String):void{
            var _local3:String;
            var _local4:String;
            var _local5:String;
            var _local6:Array;
            var _local7:int;
            var _local8:int;
            var _local9:Array = this.requesters[_arg2];
            if (_local9 == null)
            {
                trace(("No requesters found for " + _arg2));
                _local6 = _arg2.split("?");
                _local3 = _local6.pop();
                trace(("Checking for match on url query vars: " + _local3));
                for (_local4 in this.requesters)
                {
                    trace((("  found url " + _local4) + " in requesters"));
                    _local5 = _local4.split("?").pop();
                    trace(("  qv = " + _local5));
                    if (_local5 == _local3)
                    {
                        trace("Found a match");
                        _arg2 = _local4;
                        _local9 = this.requesters[_arg2];
                        break;
                    };
                };
            };
            if ((((_local9 == null)) && (Constants.LOCAL)))
            {
                _local6 = _arg2.split("/");
                _arg2 = _local6[(_local6.length - 1)];
                _local9 = this.requesters[_arg2];
            };
            if (_local9 != null)
            {
                _local7 = _local9.length;
                _local8 = 0;
                while (_local8 < _local7)
                {
                    this.copyAssetFor(_arg1, _local9[_local8], _arg2);
                    _local8++;
                };
            } else
            {
                Tracer.out(("AssetManager > bitmapAssetLoaded: ERROR no requesters found for url " + _arg2));
                return;
            };
            delete this.requesters[_arg2];
            this.assets[_arg2] = _arg1;
        }
        function swfAssetLoaded(_arg1:Class, _arg2:String):void{
            var _local3:Array;
            var _local4:int;
            var _local5:int;
            var _local6:Array = this.requesters[_arg2];
            if ((((_local6 == null)) && (Constants.LOCAL)))
            {
                _local3 = _arg2.split("/");
                _arg2 = _local3[(_local3.length - 1)];
                _local6 = this.requesters[_arg2];
            };
            if (_local6 != null)
            {
                _local4 = _local6.length;
                _local5 = 0;
                while (_local5 < _local4)
                {
                    this.instantiateAssetFor(_arg1, _local6[_local5], _arg2);
                    _local5++;
                };
            };
            this.assets[_arg2] = _arg1;
            delete this.requesters[_arg2];
        }
        function loadFailed(_arg1:String):void{
            var _local2:int;
            var _local3:int;
            var _local4:Object;
            var _local5:Array = this.requesters[_arg1].concat();
            delete this.requesters[_arg1];
            if (_local5 != null)
            {
                _local2 = _local5.length;
                _local3 = 0;
                while (_local3 < _local2)
                {
                    _local4 = _local5[_local3];
                    if (_local4.loadFailed)
                    {
                        _local4.loadFailed(_arg1);
                    };
                    _local3++;
                };
            };
        }
        private function copyAssetFor(_arg1:Bitmap, _arg2:Object, _arg3:String):void{
            var _local4:Bitmap = new Bitmap(_arg1.bitmapData.clone());
            _arg2.assetLoaded(_local4, _arg3);
        }
        private function instantiateAssetFor(_arg1:Class, _arg2:Object, _arg3:String):void{
            var _local4:* = new (_arg1)();
            _arg2.assetLoaded(_local4, _arg3);
        }

    }
}//package com.viroxoty.fashionista.asset

