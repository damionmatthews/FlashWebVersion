// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.asset.AssetLoader

package com.viroxoty.fashionista.asset{
    import flash.events.EventDispatcher;
    import flash.system.LoaderContext;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.display.LoaderInfo;
    import flash.events.IOErrorEvent;
    import flash.events.*;
    import flash.net.*;
    import flash.display.*;
    import flash.system.*;
    import com.viroxoty.fashionista.util.*;

    public class AssetLoader extends EventDispatcher {

        private static const MAX_SIMULTANEOUS:int = 5;

        private static var instance:AssetLoader;
        public static var PNG_SIMULTANEOUS:int = 4;

        private var manager:AssetManager;
        private var loaders:Array;
        private var loaderContext:LoaderContext;
        private var queue:Array;
        private var curLoads:int;
        private var pendingQueue:Array;

        public function AssetLoader(_arg1:AssetManager){
            var _local2:Loader;
            var _local3:int;
            super();
            instance = this;
            this.manager = _arg1;
            this.queue = [];
            this.loaders = [];
            this.curLoads = 0;
            this.pendingQueue = [];
            this.loaderContext = new LoaderContext(true);
            this.loaderContext.securityDomain = SecurityDomain.currentDomain;
            while (_local3 < MAX_SIMULTANEOUS)
            {
                _local2 = new Loader();
                _local2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.assetLoaded);
                _local2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
                _local2.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
                this.loaders.push({
                    "id":_local3,
                    "avail":true,
                    "loader":_local2,
                    "url":""
                });
                _local3++;
            };
        }
        public static function getInstance():AssetLoader{
            return (instance);
        }

        function loadAsset(_arg1:AssetDataObject):void{
            var _local2:String = _arg1.url;
            this.queue.push(_arg1);
            if (this.curLoads < MAX_SIMULTANEOUS)
            {
                this.loadNextAsset();
            };
        }
        public function prioritizeAssetType(_arg1:String):void{
            var _local2:AssetDataObject;
            var _local6:int;
            trace(("prioritizing assetType " + _arg1));
            var _local3:Array = [];
            var _local4:Array = [];
            var _local5:int = this.queue.length;
            while (_local6 < _local5)
            {
                _local2 = this.queue[_local6];
                if (_local2.assetType == _arg1)
                {
                    _local3.push(_local2);
                } else
                {
                    _local4.push(_local2);
                };
                _local6++;
            };
            this.queue = _local3.concat(_local4);
        }
        public function prioritizeCategory(_arg1:String):void{
            var _local2:AssetDataObject;
            var _local3:Array;
            var _local4:int;
            var _local5:Boolean;
            var _local6:int;
            var _local10:int;
            trace(("prioritizing category " + _arg1));
            var _local7:Array = [];
            var _local8:Array = [];
            var _local9:int = this.queue.length;
            while (_local10 < _local9)
            {
                _local2 = this.queue[_local10];
                _local3 = _local2.category.split(",");
                _local4 = _local3.length;
                _local5 = false;
                _local6 = 0;
                while (_local6 < _local4)
                {
                    if (_local3[_local6] == _arg1)
                    {
                        _local5 = true;
                        break;
                    };
                    _local6++;
                };
                if (_local5)
                {
                    _local7.push(_local2);
                } else
                {
                    _local8.push(_local2);
                };
                _local10++;
            };
            this.queue = _local7.concat(_local8);
        }
        function holdCurrentQueue():void{
            var _local1:Array = this.pendingQueue.concat();
            this.pendingQueue = this.queue.concat(_local1);
            this.queue = [];
        }
        private function loadNextAsset():void{
            var _local1:String;
            var _local2:AssetDataObject;
            var _local3:Object;
            var _local5:int;
            if (this.queue.length > 0)
            {
                _local2 = this.queue.shift();
            } else
            {
                if (this.pendingQueue.length > 0)
                {
                    _local2 = this.pendingQueue.shift();
                } else
                {
                    return;
                };
            };
            _local1 = _local2.url;
            this.curLoads++;
            var _local4:URLRequest = new URLRequest(_local1);
            while (_local5 < MAX_SIMULTANEOUS)
            {
                _local3 = this.loaders[_local5];
                if (_local3.avail)
                {
                    if (((Constants.LOCAL) || ((_local1.indexOf(".swf") > -1))))
                    {
                        _local3.loader.load(_local4);
                    } else
                    {
                        _local3.loader.load(_local4, this.loaderContext);
                    };
                    _local3.avail = false;
                    _local3.url = _local1;
                    return;
                };
                _local5++;
            };
        }
        private function assetLoaded(_arg1:Event):void{
            var _local2:String;
            var _local3:Object;
            var _local4:ApplicationDomain;
            var _local5:Class;
            var _local9:int;
            var _local6:Loader = _arg1.currentTarget.loader;
            var _local7:* = _arg1.currentTarget.loader.content;
            var _local8:String = _arg1.currentTarget.loader.contentLoaderInfo.url;
            while (_local9 < MAX_SIMULTANEOUS)
            {
                _local3 = this.loaders[_local9];
                if (_local6 == _local3.loader)
                {
                    _local2 = _local3.url;
                    Tracer.out(("AssetLoader > assetLoaded: original url " + _local2));
                    break;
                };
                _local9++;
            };
            if ((_local7 is MovieClip))
            {
                _local4 = (_arg1.target as LoaderInfo).content.loaderInfo.applicationDomain;
                _local5 = Class(_local4.getDefinition("asset"));
                this.manager.swfAssetLoaded(_local5, _local2);
            } else
            {
                this.manager.bitmapAssetLoaded((_local7 as Bitmap), _local2);
            };
            this.freeUp(_local6);
        }
        private function freeUp(_arg1:Loader):void{
            var _local2:Object;
            var _local3:int;
            while (_local3 < MAX_SIMULTANEOUS)
            {
                _local2 = this.loaders[_local3];
                if (_local2.loader == _arg1)
                {
                    _local2.avail = true;
                    break;
                };
                _local3++;
            };
            this.curLoads--;
            this.loadNextAsset();
        }
        private function httpStatusHandler(_arg1:HTTPStatusEvent):void{
        }
        private function ioErrorHandler(_arg1:IOErrorEvent):void{
            var _local2:String;
            var _local3:Loader;
            var _local4:Object;
            var _local6:int;
            var _local5:LoaderInfo = (_arg1.target as LoaderInfo);
            while (_local6 < MAX_SIMULTANEOUS)
            {
                _local4 = this.loaders[_local6];
                if (_local4.loader.contentLoaderInfo == _local5)
                {
                    _local2 = _local4.url;
                    _local3 = _local4.loader;
                    break;
                };
                _local6++;
            };
            Tracer.out(("AssetLoader > ioErrorHandler on url: " + _local2));
            this.freeUp(_local3);
            this.manager.loadFailed(_local2);
        }

    }
}//package com.viroxoty.fashionista.asset

