// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.ImageLoader

package com.viroxoty.fashionista.ui{
    import flash.display.DisplayObjectContainer;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.util.*;

    public class ImageLoader {

        var url:String;
        var container:DisplayObjectContainer;
        var target_height:Number;
        var target_width:Number;
        var x_offset:Number;
        var y_offset:Number;

        public function ImageLoader(_arg1:String, _arg2:DisplayObjectContainer, _arg3:Number=0, _arg4:Number=0, _arg5:Number=0, _arg6:Number=0){
            this.url = _arg1;
            this.container = _arg2;
            this.target_height = _arg3;
            this.target_width = _arg4;
            this.x_offset = _arg5;
            this.y_offset = _arg6;
            var _local7:AssetDataObject = new AssetDataObject();
            _local7.parseURL(this.url);
            AssetManager.getInstance().getAssetFor(_local7, this);
        }
        public function assetLoaded(_arg1:DisplayObject, _arg2:String):void{
            Tracer.out(("ImageLoader > assetLoaded : " + _arg2));
            if (this.target_height > 0)
            {
                Util.scaleAndCenterDisplayObject(_arg1, this.target_height, this.target_width);
                _arg1.x = (_arg1.x + this.x_offset);
                _arg1.y = (_arg1.y + this.y_offset);
            };
            if (this.container)
            {
                this.container.addChild(_arg1);
            };
        }
        public function loadFailed(_arg1:String):void{
            Tracer.out(("ImageLoader > loadFailed :" + _arg1));
        }

    }
}//package com.viroxoty.fashionista.ui

