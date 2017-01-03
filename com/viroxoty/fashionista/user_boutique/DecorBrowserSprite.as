// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.DecorBrowserSprite

package com.viroxoty.fashionista.user_boutique{
    import flash.display.Sprite;
    import com.viroxoty.fashionista.data.Decor;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.geom.Rectangle;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class DecorBrowserSprite extends Sprite {

        var data:Decor;
        var badge:MovieClip;

        public function DecorBrowserSprite(_arg1:Decor){
            this.data = _arg1;
        }
        public function loadAsset(){
            var _local1:AssetDataObject = new AssetDataObject();
            _local1.parseURL(this.data.swf);
            AssetManager.getInstance().getAssetFor(_local1, this);
        }
        public function assetLoaded(_arg1:MovieClip, _arg2:String):void{
            var _local3:Sprite;
            Tracer.out(("DecorBrowserSprite > assetLoaded: " + _arg2));
            var _local4:MovieClip = (MainViewController.getInstance().get_game_asset("decor_outline") as MovieClip);
            addChild(_local4);
            _local3 = new Sprite();
            _local3.addChild(_arg1);
            var _local5:Number = (DecorBrowserController.SWF_CONTAINER_SIZE - 10);
            var _local6:Rectangle = Util.getVisibleBoundingRectForAsset(_arg1);
            _arg1.x = -(_local6.x);
            _arg1.y = -(_local6.y);
            var _local7:Number = (_local5 / _local6.width);
            var _local8:Number = (_local5 / _local6.height);
            var _local9:Number = Math.min(_local7, _local8);
            _local3.scaleX = _local9;
            _local3.scaleY = _local9;
            _local3.x = (5 + ((_local5 - (_local6.width * _local9)) / 2));
            _local3.y = (5 + ((_local5 - (_local6.height * _local9)) / 2));
            addChild(_local3);
            var _local10:MovieClip = (MainViewController.getInstance().get_game_asset("decor_corners") as MovieClip);
            addChild(_local10);
            this.badge = (MainViewController.getInstance().get_game_asset("decor_badge") as MovieClip);
            if (this.data.userDecors.length > 0)
            {
                this.badge.label.text = this.data.decorsAvailable;
            } else
            {
                this.badge.visible = false;
            };
            addChild(this.badge);
        }
        public function loadFailed(_arg1:String){
            Tracer.out(("DecorBrowserSprite > loadFailed: " + _arg1));
        }
        public function updateBadgeCount(_arg1:int){
            this.badge.visible = true;
            this.badge.label.text = _arg1;
        }

    }
}//package com.viroxoty.fashionista.user_boutique

