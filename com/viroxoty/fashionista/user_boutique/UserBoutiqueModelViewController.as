// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.UserBoutiqueModelViewController

package com.viroxoty.fashionista.user_boutique{
    import com.viroxoty.fashionista.AvatarController;
    import com.viroxoty.fashionista.data.UserBoutiqueModel;
    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.display.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.util.*;

    public class UserBoutiqueModelViewController extends UserBoutiqueObjectViewController {

        public static const AVATAR_READY:String = "AVATAR_READY";
        public static const MIN_SCALE:Number = 0.5;
        public static const MAX_SCALE:Number = 5;
        static const DRESSUP_X:Number = 200;
        static const DRESSUP_Y:Number = 265;

        public var avatar_controller:AvatarController;
        var initial_dressup:Boolean = false;

        public function UserBoutiqueModelViewController(_arg1:UserBoutiqueModel){
            Tracer.out(("new UserBoutiqueModelViewController for model id " + _arg1.id));
            _data = _arg1;
            super();
            scale_max = MAX_SCALE;
            scale_min = MIN_SCALE;
            this.avatar_controller = new AvatarController();
        }
        public function init_avatar(_arg1:int, _arg2:Boolean=false){
            this.avatar_controller.mode = _arg1;
            this.initial_dressup = _arg2;
            this.avatar_controller.addEventListener(AvatarController.ITEMS_LOADED, this.check_initial_dressup, false, 0, true);
            this.avatar_controller.init();
            this.avatar_controller.get_avatar_mc_for(this);
        }
        public function destroy(){
            this.avatar_controller.removeEventListener(AvatarController.ITEMS_LOADED, this.check_initial_dressup);
        }
        public function set_avatar_mc(_arg1:MovieClip):void{
            _arg1.alpha = 0;
            this.setup(_arg1);
            this.avatar_controller.set_styles(this.model.style_obj);
            dispatchEvent(new Event(AVATAR_READY));
        }
        function check_initial_dressup(_arg1=null){
            if (this.initial_dressup)
            {
                this.initial_dressup = false;
                this.avatar_controller.removeEventListener(AvatarController.ITEMS_LOADED, this.check_initial_dressup);
                Tracer.out("check_initial_dressup > removing model interactivity");
                this.avatar_controller.remove_model_interactivity();
            };
        }
        public function get_avatar_mc():MovieClip{
            return ((asset.getChildAt(0) as MovieClip));
        }
        public function to_dressup_position():void{
            asset.scaleX = 1;
            asset.scaleY = 1;
            x = DRESSUP_X;
            y = DRESSUP_Y;
        }
        public function to_default_position():void{
            asset.scaleX = 1;
            asset.scaleY = 1;
            x = DRESSUP_X;
            y = DRESSUP_Y;
            _data.scale = 1;
            _data.x_pos = x;
            _data.y_pos = y;
        }
        public function reset():void{
            this.to_default_position();
            this.set_default_outfit();
        }
        function set_default_outfit():void{
            this.avatar_controller.remove_all();
            this.model.items = DressingRoom.get_default_clothing();
            this.avatar_controller.dress_with_items(this.model.items, false);
        }
        public function revert_position():void{
            asset.scaleX = _data.scale;
            asset.scaleY = Math.abs(_data.scale);
            x = _data.x_pos;
            y = _data.y_pos;
        }
        public function zoom_in():void{
            if (asset.scaleX != 4)
            {
                Tweener.removeTweens(asset);
                Tweener.removeTweens(this);
                Tweener.addTween(asset, {
                    "scaleX":4,
                    "scaleY":4,
                    "time":0.4,
                    "transition":"none"
                });
                Tweener.addTween(this, {
                    "x":DRESSUP_X,
                    "y":(DRESSUP_Y + 525),
                    "time":0.4,
                    "transition":"none"
                });
            };
        }
        public function zoom_out():void{
            if (asset.scaleX != 1)
            {
                Tweener.removeTweens(asset);
                Tweener.removeTweens(this);
                Tweener.addTween(asset, {
                    "scaleX":1,
                    "scaleY":1,
                    "time":0.4,
                    "transition":"none"
                });
                Tweener.addTween(this, {
                    "x":DRESSUP_X,
                    "y":DRESSUP_Y,
                    "time":0.4,
                    "transition":"none"
                });
            };
        }
        function setup(_arg1:DisplayObject){
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
        override public function setScale():void{
            _data.scale = asset.scaleX;
            DataManager.getInstance().update_my_boutique_model(this.data);
        }
        public function get data():UserBoutiqueModel{
            return ((_data as UserBoutiqueModel));
        }
        public function set data(_arg1:UserBoutiqueModel):void{
            _data = _arg1;
        }
        public function get zoomed_in():Boolean{
            return ((asset.scaleX > 1));
        }
        function get model():UserBoutiqueModel{
            return ((_data as UserBoutiqueModel));
        }

    }
}//package com.viroxoty.fashionista.user_boutique

