// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.ItemSprite

package com.viroxoty.fashionista.ui{
    import flash.display.Sprite;
    import com.viroxoty.fashionista.data.Item;
    import flash.geom.Rectangle;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.events.*;
    import flash.net.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class ItemSprite extends Sprite {

        static const BORDER:int = 5;

        var data:Item;
        var targetWidth:Number;
        var targetHeight:Number;

        public function ItemSprite(_arg1:Item, _arg2:Number, _arg3:Number){
            this.data = _arg1;
            this.targetWidth = _arg2;
            this.targetHeight = _arg3;
            this.loadAsset();
        }
        public function loadAsset(){
            var image_loaded:Function;
            image_loaded = function (_arg1:Event){
                var _local2:Rectangle;
                var _local3:Loader = LoaderInfo(_arg1.currentTarget).loader;
                _local2 = Util.getVisibleBoundingRectForAsset(_local3);
                _local3.x = -(_local2.x);
                _local3.y = -(_local2.y);
                var _local4:Number = (targetWidth / _local2.width);
                var _local5:Number = (targetHeight / _local2.height);
                var _local6:Number = Math.min(_local4, _local5);
                scaleX = _local6;
                scaleY = _local6;
                x = (BORDER + ((targetWidth - (_local2.width * _local6)) / 2));
                y = (BORDER + ((targetHeight - (_local2.height * _local6)) / 2));
            };
            var image_request:URLRequest = new URLRequest(this.data.swf);
            var image_loader:Loader = new Loader();
            image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, image_loaded);
            image_loader.load(image_request);
            addChild(image_loader);
        }

    }
}//package com.viroxoty.fashionista.ui

