// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.DecorViewController

package com.viroxoty.fashionista.user_boutique{
    import com.viroxoty.fashionista.data.UserDecor;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.util.*;

    public class DecorViewController extends UserBoutiqueObjectViewController {

        public static const MIN_SCALE:Number = 0.1;
        public static const MAX_SCALE:Number = 10;

        public function DecorViewController(_arg1:UserDecor){
            _data = _arg1;
            super();
            scale_max = MAX_SCALE;
            scale_min = MIN_SCALE;
        }
        public function loadAsset(){
            var _local1:AssetDataObject = new AssetDataObject();
            _local1.parseURL(this.data.decor.swf);
            AssetManager.getInstance().getAssetFor(_local1, this);
        }
        public function assetLoaded(_arg1:MovieClip, _arg2:String):void{
            if (DecorManager.not_wall_floor(this))
            {
                this.setup_decor(_arg1);
            } else
            {
                this.setup_wall_floor(_arg1);
            };
            dispatchEvent(new Event(DecorManager.EVENT_DECOR_LOADED));
        }
        function setup_wall_floor(_arg1:MovieClip){
            asset = _arg1;
            addChild(asset);
        }
        function setup_decor(_arg1:DisplayObject){
            artWidth = _arg1.width;
            artHeight = _arg1.height;
            ratio = (artWidth / artHeight);
            asset = new Sprite();
            asset.addChild(_arg1);
            var _local2:Rectangle = _arg1.getBounds(asset);
            trace(((((((("canvas element > setup, art bounds in asset coordinate space.  x = " + _local2.x) + ", y = ") + _local2.y) + ", width = ") + _local2.width) + ", height = ") + _local2.height));
            _arg1.x = (-((_local2.width / 2)) + (_arg1.x - _local2.x));
            _arg1.y = (-((_local2.height / 2)) + (_arg1.y - _local2.y));
            asset.scaleX = _data.scale;
            asset.scaleY = Math.abs(_data.scale);
            addChild(asset);
        }
        public function get data():UserDecor{
            return ((_data as UserDecor));
        }
        public function getName():String{
            return (this.data.name);
        }
        override public function setScale():void{
            this.data.scale = asset.scaleX;
            DataManager.getInstance().position_decor(this.data);
        }

    }
}//package com.viroxoty.fashionista.user_boutique

