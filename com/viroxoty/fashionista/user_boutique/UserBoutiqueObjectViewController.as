// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.UserBoutiqueObjectViewController

package com.viroxoty.fashionista.user_boutique{
    import flash.display.Sprite;
    import com.viroxoty.fashionista.data.TransformableObject;
    import flash.geom.Point;
    import flash.geom.*;

    public class UserBoutiqueObjectViewController extends Sprite {

        public static const CHANGED:String = "changed";
        public static const CHANGED_POSITION:String = "changedPosition";
        public static const CHANGED_ROTATION:String = "changedRotation";
        public static const CHANGED_BOUNDS:String = "changedBounds";
        public static const DESTROY:String = "destroy";
        public static const SELECTION_TOGGLED:String = "selectionToggle";

        protected var _data:TransformableObject;
        var asset:Sprite;
        var x_offset:Number;
        var y_offset:Number;
        protected var artWidth:Number;
        protected var artHeight:Number;
        var scale_max:Number;
        var scale_min:Number;
        protected var ratio:Number;

        public function UserBoutiqueObjectViewController(){
            x = this._data.x_pos;
            y = this._data.y_pos;
        }
        public function getAsset():Sprite{
            return (this.asset);
        }
        public function adjustAssetScale(_arg1:Number, _arg2:Number):void{
            var _local3:Number = (this._data.scale * _arg1);
            var _local4:int = (_local3 / Math.abs(_local3));
            _local3 = Math.abs(_local3);
            _local3 = this.constrain_scale(_local3);
            this.asset.scaleX = (_local4 * _local3);
            var _local5:Number = Math.abs((this._data.scale * _arg2));
            _local5 = this.constrain_scale(_local5);
            this.asset.scaleY = _local5;
        }
        public function constrain_scale(_arg1:Number):Number{
            _arg1 = Math.min(_arg1, this.scale_max);
            _arg1 = Math.max(_arg1, this.scale_min);
            return (_arg1);
        }
        public function setScale():void{
        }
        function getOrigin():Point{
            var _local1:Point = this.localToGlobal(new Point());
            return (_local1);
        }
        function getRatio():Number{
            return (this.ratio);
        }
        public function reset_data():void{
            this._data.scale = 1;
            this._data.x_pos = 0;
            this._data.y_pos = 0;
            this._data.z_pos = 0;
        }

    }
}//package com.viroxoty.fashionista.user_boutique

