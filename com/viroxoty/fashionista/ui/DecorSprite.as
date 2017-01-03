// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.DecorSprite

package com.viroxoty.fashionista.ui{
    import flash.display.Sprite;
    import com.viroxoty.fashionista.data.Decor;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.geom.Rectangle;
    import flash.display.MovieClip;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.util.*;

    public class DecorSprite extends Sprite {

        var data:Decor;
        var targetWidth:Number;
        var targetHeight:Number;

        public function DecorSprite(_arg1:Decor, _arg2:Number, _arg3:Number){
            this.data = _arg1;
            this.targetWidth = _arg2;
            this.targetHeight = _arg3;
            this.loadAsset();
        }
        public function loadAsset(){
            var _local1:AssetDataObject = new AssetDataObject();
            _local1.parseURL(this.data.swf);
            AssetManager.getInstance().getAssetFor(_local1, this);
        }
        public function assetLoaded(_arg1:MovieClip, _arg2:String):void{
            Tracer.out(("DecorBrowserSprite > assetLoaded: " + _arg2));
            var _local3:Sprite = new Sprite();
            _local3.addChild(_arg1);
            var _local4:Rectangle = Util.getVisibleBoundingRectForAsset(_arg1);
            _arg1.x = -(_local4.x);
            _arg1.y = -(_local4.y);
            var _local5:Number = (this.targetWidth / _local4.width);
            var _local6:Number = (this.targetHeight / _local4.height);
            var _local7:Number = Math.min(_local5, _local6);
            _local3.scaleX = _local7;
            _local3.scaleY = _local7;
            _local3.x = (5 + ((this.targetWidth - (_local4.width * _local7)) / 2));
            _local3.y = (5 + ((this.targetHeight - (_local4.height * _local7)) / 2));
            addChild(_local3);
        }
        public function loadFailed(_arg1:String){
            Tracer.out(("DecorBrowserSprite > loadFailed: " + _arg1));
        }

    }
}//package com.viroxoty.fashionista.ui

